import com.jogamp.common.nio.Buffers;
import com.jogamp.newt.opengl.GLWindow;
import com.jogamp.opengl.GL4;
import com.jogamp.opengl.DebugGL4;
import com.jogamp.opengl.TraceGL4;
import com.jogamp.opengl.GLCapabilities;
import com.jogamp.opengl.GLProfile;
import com.jogamp.opengl.GLAutoDrawable;

import java.nio.Buffer;
import java.nio.IntBuffer;
import java.nio.ByteBuffer;
import java.nio.FloatBuffer;

public final class ComputeShader extends ShaderProgram {
  private int numBuffers, bufferHandles[];
  public Buffer[] buffers;

  public ComputeShader(String shaderCode, int numBuffers) {
    super(new int[]{GL4.GL_COMPUTE_SHADER}, new String[]{shaderCode});
    this.allocateBuffers(numBuffers);
  }

  private void upload() {
    //final int NUM_FLOATS_IN_SHADER = 1;
    //final int NUM_ELEMENTS_IN_BUFFER = 64;
    final int FLOAT_SIZE_BYTES = 4;
    //this.buffers[0] = Buffers.newDirectFloatBuffer(NUM_ELEMENTS_IN_BUFFER * NUM_FLOATS_IN_SHADER);
    for (int i=0; i<this.numBuffers; i++) {
      this.gl.glBindBuffer(GL4.GL_ARRAY_BUFFER, this.bufferHandles[i]); // Select the VBO, GPU memory data, to use for vertices
      this.gl.glBufferData(GL4.GL_ARRAY_BUFFER, this.buffers[i].capacity() * FLOAT_SIZE_BYTES, this.buffers[i], GL4.GL_DYNAMIC_DRAW); // copy data from CPU -> GPU memory  //target, size, data, "hint"??
      this.gl.glBindBuffer(GL4.GL_ARRAY_BUFFER, 0);
    }
  }

  public void startCompute() {
    this.gl.glUseProgram(programId);
  }

  public void compute(int gx, int gy, int gz, int sx, int sy, int sz) {
    //this.gl.glUniform1f(this.gl.glGetUniformLocation(this.programId, "delta"), 5);
    for (int i=0; i<this.numBuffers; i++)
      this.gl.glBindBufferBase(GL4.GL_SHADER_STORAGE_BUFFER, i, this.bufferHandles[i]); 
    this.gl.glDispatchComputeGroupSizeARB(gx, gy, gz, sx, sy, sz); 
    for (int i=0; i<this.numBuffers; i++)
      this.gl.glBindBufferBase(GL4.GL_SHADER_STORAGE_BUFFER, i, 0);
    this.gl.glUseProgram(0);
  }

  public void download() {
    final int FLOAT_SIZE_BYTES = 4;
    for (int i=0; i<this.numBuffers; i++) {
      this.gl.glBindBuffer(GL4.GL_ARRAY_BUFFER, this.bufferHandles[i]); // Select the VBO, GPU memory data, to use for vertices
      this.gl.glGetBufferSubData(GL4.GL_ARRAY_BUFFER, 0, this.buffers[i].capacity() * FLOAT_SIZE_BYTES, this.buffers[i]); //target, offset, size, data
      this.gl.glBindBuffer(GL4.GL_ARRAY_BUFFER, 0);
    }
  }

  public void allocateBuffers(int numBuffers) {
    this.numBuffers = numBuffers;
    this.bufferHandles = new int[this.numBuffers];
    this.gl.glGenBuffers(this.numBuffers, this.bufferHandles, 0); //numberOfBuffers, *handles, ???keinPlan???
    this.buffers = new Buffer[this.numBuffers];
  }
}

public class ShaderProgram {
  protected final GL4 gl;
  protected final int programId, shaderIds[];

  public ShaderProgram(int[] shaderTypes, String[] shaderCodes) {
    this.gl = getGL4(true);
    this.programId = this.gl.glCreateProgram();
    this.shaderIds = new int[shaderTypes.length];
    for (int i=0; i<shaderTypes.length; i++)
      this.shaderIds[i] = this.gl.glCreateShader(shaderTypes[i]);
    for (int i=0; i<shaderTypes.length; i++)
      this.compileShader(this.shaderIds[i], shaderCodes[i]);
    this.linkProgram();
  }

  public void compileShader(int shaderId, String code) {
    if (shaderId == 0)
      this.stop("Error creating shader. Shader id is zero."); 
    this.gl.glShaderSource(shaderId, 1, new String[] { code }, null); 
    this.gl.glCompileShader(shaderId); 
    this.validateShader(shaderId);
  }

  public void linkProgram() {
    for (int i=0; i<this.shaderIds.length; i++)
      this.gl.glAttachShader(this.programId, this.shaderIds[i]); 
    this.gl.glLinkProgram(this.programId); 
    this.validateProgram();
  }

  public void disposeProgram() {
    for (int i=0; i<this.shaderIds.length; i++) {
      this.gl.glDetachShader(this.programId, this.shaderIds[i]);
      this.gl.glDeleteShader(this.shaderIds[i]);
    }
    this.gl.glDeleteProgram(this.programId);
  }

  //-------------------------------------------- Validation and Error Handling ----------------------------------------

  private void validateShader(int shaderId) {
    IntBuffer intBuffer = IntBuffer.allocate(1); 
    this.gl.glGetShaderiv(shaderId, GL4.GL_COMPILE_STATUS, intBuffer); 
    if (intBuffer.get(0) != 1) {
      this.gl.glGetShaderiv(shaderId, GL4.GL_INFO_LOG_LENGTH, intBuffer); 
      int size = intBuffer.get(0); 
      if (size > 0) {
        ByteBuffer byteBuffer = ByteBuffer.allocate(size); 
        this.gl.glGetShaderInfoLog(shaderId, size, intBuffer, byteBuffer); 
        println(new String(byteBuffer.array()));
      }
      this.stop("Error compiling shader!");
    }
  }

  private void validateProgram() {
    IntBuffer intBuffer = IntBuffer.allocate(1); 
    this.gl.glGetProgramiv(this.programId, GL4.GL_LINK_STATUS, intBuffer); 
    if (intBuffer.get(0) != 1) {
      this.gl.glGetProgramiv(this.programId, GL4.GL_INFO_LOG_LENGTH, intBuffer); 
      int size = intBuffer.get(0); 
      if (size > 0) {
        ByteBuffer byteBuffer = ByteBuffer.allocate(size); 
        this.gl.glGetProgramInfoLog(this.programId, size, intBuffer, byteBuffer); 
        System.out.println(new String(byteBuffer.array()));
      }
      this.stop("Error linking shader program!");
    }

    this.gl.glValidateProgram(this.programId); 
    intBuffer = IntBuffer.allocate(1); 
    this.gl.glGetProgramiv(this.programId, GL4.GL_VALIDATE_STATUS, intBuffer); 
    if (intBuffer.get(0) != 1) {
      this.gl.glGetProgramiv(this.programId, GL4.GL_INFO_LOG_LENGTH, intBuffer); 
      int size = intBuffer.get(0); 
      if (size > 0) {
        ByteBuffer byteBuffer = ByteBuffer.allocate(size); 
        this.gl.glGetProgramInfoLog(this.programId, size, intBuffer, byteBuffer); 
        println(new String(byteBuffer.array()));
      }
      this.stop("Error validating shader program!");
    }
  }

  public void stop(String msg) {
    this.gl.getContext().destroy();
    System.out.println("Stop: "+msg);
  }
}

GL4 getGL4(boolean debug) {
  final GLCapabilities caps = new GLCapabilities(GLProfile.get(GLProfile.GL4));

  GLAutoDrawable glWindow = GLWindow.create(caps);
  ((GLWindow)glWindow).setVisible(true);
  ((GLWindow)glWindow).setSize(1, 1);
  if (debug)
    glWindow.setGL(new TraceGL4(new DebugGL4(glWindow.getGL().getGL4()), System.out));
  glWindow.getContext().makeCurrent();
  return glWindow.getGL().getGL4();
}
