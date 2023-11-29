# Godot4.1.3 Shader Viewport Example

This is a basic project to demonstrates the 'correct' way to use Viewports as source images for shaders that write back into the viewports.

## The wrong way

When trying to write a shader that uses a SubViewport as it's texture source and then renders into that same Viewport you get the followiing error.

```
E 0:00:00:0784   RenderingDeviceVulkan::draw_list_bind_uniform_set: Attempted to use the same texture in framebuffer attachment and a uniform (set: 1, binding: 1), this is not allowed. <C++ Error>    Condition "attachable_ptr[i].texture == bound_ptr[j]" is true.   drivers\vulkan\rendering_device_vulkan.cpp:7241 @ RenderingDeviceVulkan::draw_list_bind_uniform_set()
```

Ironically the solution still workes but the error is persitant.The error is a warning that is there to protect you from doing things that may have unpredicatable results and different machines. This was explained to me by clayjohn in the post [here](https://github.com/godotengine/godot/issues/81928).

You can not have.

```
SubViewport
    ColorRect
        Material
            Shader that referances SubviewPort output.
```

## The right way

The correct method it to have a second SubViewport that is a buffer between the two so you are not reading from and writting to a viewport at the same time.

```
SubViewport
    ColorRect
        Material
            Shader that referances SubViewport2 output.
SubViewport2
    Sprite
        ViewportTexture of SubViewport
            
```

