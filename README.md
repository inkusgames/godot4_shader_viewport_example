# Godot4.1.3 Shader Viewport Example

This is a basic project to demonstrates the 'correct' way to use Viewports as source images for shaders that write back into the viewports.

## The wrong way

When trying to write a shader that uses a SubViewport as a texture source and then render into that same Viewport you get the following error.

```
E 0:00:00:0784   RenderingDeviceVulkan::draw_list_bind_uniform_set: Attempted to use the same texture in framebuffer attachment and a uniform (set: 1, binding: 1), this is not allowed. <C++ Error>    Condition "attachable_ptr[i].texture == bound_ptr[j]" is true.   drivers\vulkan\rendering_device_vulkan.cpp:7241 @ RenderingDeviceVulkan::draw_list_bind_uniform_set()
```

While the incorrect solution may still work the error logging is persitant.

It turns out that the error is there because you are implementing unpredictable behaviour. It is there to make you aware you are doing things that may not work on different machines. This was explained to me by clayjohn in the post [here](https://github.com/godotengine/godot/issues/81928).

You can not have.

```
SubViewport
    ColorRect
        Material
            Shader that referances SubviewPort output.
```

## The right way

The correct method is to have a second SubViewport that is a buffer between the First viewport and the shader two so you are not reading from and writting to a viewport at the same time.

```
SubViewport
    ColorRect
        Material
            Shader that referances SubViewport2 output.
SubViewport2
    Sprite
        ViewportTexture of SubViewport
            
```

## The Project

This project has the two viewports. In the one is the Shader on a ColorRect. It's shader uses the other Viewport as it's texture source. Each draw it increments and loops the Red color of the texure. This viewport texture is then rendered into a sprite in the second Viewport. The shader uses the second viewport as the source so it does not read directly from the same texure it writes to. This allows the shader to write data ino the texture but reading from texture two while writting to texture one. Effectivly double buffering the solution.
