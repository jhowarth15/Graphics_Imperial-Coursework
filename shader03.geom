/************************************************************************/
/*    Graphics 317 coursework exercise 03                               */
/*    Author: Bernhard Kainz                                            */
/*    This file has to be altered for this exercise                     */
/************************************************************************/

#version 150 compatibility
#extension GL_ARB_geometry_shader4 : enable

layout (max_vertices = 72) out;

const float pi = 3.14159265359;

////////////////
uniform vec4 ambientColor;
uniform vec4 diffuseColor;
uniform vec4 specularColor;
uniform float specularExponent;

uniform int level;
uniform float time;

in vertexData
{
	vec3 pos;
	vec3 normal;
	vec4 color;
}vertices[];

out fragmentData
{
	vec3 vpos;
	vec3 normal;
	vec4 color;
}frag;   


///////////////////////////////////////////////////////
//pseudo random helper function
///////////////////////////////////////////////////////
float rnd(vec2 x)
{
	int n = int(x.x * 40.0 + x.y * 6400.0);
	n = (n << 13) ^ n;
	return 1.0 - float( (n * (n * n * 15731 + 789221) + 1376312589) & 0x7fffffff) / 1073741824.0;
}


///////////////////////////////////////////////////////
//TODO add code for exercise 3 Geometry generation here
///////////////////////////////////////////////////////
void produceVertex(float s, float t, vec4 v0, vec4 v01, vec4 v02)
{
  ///////////////////////////////////////////////////////
  //TODO implement for subdivision
  ///////////////////////////////////////////////////////

  float r = (1 - s) - t;
  
  vec4 new_pos = r * v0 + s * v01 + t * v02;

  frag.vpos = r * vertices[0].pos + s * vertices[1].pos + t *  vertices[2].pos;
  frag.normal = r * vertices[0].normal + s * vertices[1].normal + t * vertices[2].normal;
  frag.color = r * vertices[0].color + s * vertices[1].color + t * vertices[2].color;

  gl_Position = new_pos;

  EmitVertex();


  ///////////////////////////////////////////////////////
}
///////////////////////////////
void main()
{
	///////////////////////////////////////////////////////
	//TODO replace pass through shader with solution
	///////////////////////////////////////////////////////


  ///////////////////////////////////////////////////////


  if (level<=3 && level>0)
  {
	for (int x = 0; x<level; x++)
	    {
		for (int y = 0; y<level-x; y++)
		    {
			// x/level and y/level are barycentric coordinates
			produceVertex(float(x)/float(level), float(y)/float(level), gl_in[0].gl_Position, gl_in[1].gl_Position, gl_in[2].gl_Position);
			produceVertex(float(x+1)/float(level), float(y)/float(level), gl_in[0].gl_Position, gl_in[1].gl_Position, gl_in[2].gl_Position);
			produceVertex(float(x)/float(level), float(y+1)/float(level), gl_in[0].gl_Position, gl_in[1].gl_Position, gl_in[2].gl_Position);
	
			EndPrimitive();
		    }


	    }

  }


  //BONUS animation - shattering

  if (level > 3 || level < 0)
  {

    for(int i = 0; i < gl_in.length(); i++)
    {
      frag.vpos = vertices[i].pos;
      frag.normal = vertices[i].normal;
      frag.color = vertices[i].color;
      vec4 pos = gl_in[i].gl_Position;
      gl_Position = pos + max(0.05 * rnd(vec2(frag.vpos)) * time * vec4(vertices[i].pos, 0), 0);
      EmitVertex();
    } 
    EndPrimitive();	


  }


	
}
