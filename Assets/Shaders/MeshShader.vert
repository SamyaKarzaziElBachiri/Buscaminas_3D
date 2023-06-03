#version 410 core


struct LightData
{
	vec4 color;
	vec4 direction;
};


//Set Binding Point of Uniform Buffer directly in the shader file, feature available from OpenGL 4.2 onwards (Windows/Linux only)
//layout(binding = 0) uniform Data
layout (row_major) uniform Data //uniform buffer Data
{
    mat4 world;
    mat4 view;
    mat4 projection;
    vec4 cameraPos;
    LightData lights[32];
    int lightsNum;
}; 


layout(location = 0) in vec3 position;
layout(location = 1) in vec2 texcoord;
layout(location = 2) in vec3 normal;

layout(location = 0) out vec2 outTexcoord;
layout(location = 1) out vec3 outNormal;
layout(location = 2) out vec3 outDirToCamera;

void main(void)
{
    vec4 pos = vec4(position, 1) * world; //multiply the world matrix with the vertex position in order to obtain the final position
    outDirToCamera = normalize(pos.xyz - cameraPos.xyz); //compute vector direction between camera and current world position of the vertex of the mesh, required to compute specular lighting
    
    pos = pos * view ; //multiply the view matrix with the world position in order to obtain the position in view space
    pos = pos * projection; //multiply the projection matrix with the view position in order to obtain the final position in screen space

    gl_Position = pos;

    outTexcoord = texcoord;
    outNormal = normalize(normal*mat3(world)); //compute normal direction in world space (since we want only to rotate the normal direction and we don't want to translate it, 
                                               //let's multiply the direction only with the 3x3 part of the matrix, that corresponds to the rotaton matrix)
}
