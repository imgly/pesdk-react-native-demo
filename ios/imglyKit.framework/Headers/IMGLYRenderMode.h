//  This file is part of the PhotoEditor Software Development Kit.
//  Copyright (C) 2016-2017 9elements GmbH <contact@9elements.com>
//  All rights reserved.
//  Redistribution and use in source and binary forms, without
//  modification, are permitted provided that the following license agreement
//  is approved and a legal/financial contract was signed by the user.
//  The license agreement can be found under the following link:
//  https://www.photoeditorsdk.com/LICENSE.txt

/**
 *  Represents the changes that should be rendered by an instance of `PhotoEditRenderer`.
 */
typedef NS_OPTIONS(NSUInteger, IMGLYRenderMode) {
    /**
     *  No changes should be rendered.
     */
    IMGLYRenderModeNone = 0,
    /**
     *  Auto-Enhancement should be rendered.
     */
    IMGLYRenderModeAutoEnhancement = 1 << 0,
    /**
     *  Orientation changes should be rendered.
     */
    IMGLYRenderModeOrientation = 1 << 1,
    /**
     *  Crop should be rendered.
     */
    IMGLYRenderModeCrop = 1 << 2,
    /**
     *  Focus should be rendered.
     */
    IMGLYRenderModeFocus = 1 << 3,
    /**
     *  Filters should be rendered.
     */
    IMGLYRenderModePhotoEffect = 1 << 4,
    /**
     *  Color adjustments should be rendered.
     */
    IMGLYRenderModeColorAdjustments = 1 << 5,
    /**
     *  Overlays (Stickers, Text and Frames) should be rendered.
     */
    IMGLYRenderModeOverlay = 1 << 6,
    /**
     *  Inset should be rendered.
     */
    IMGLYRenderModeInset = 1 << 7,
    /**
     *  Backdrop should be rendered.
     */
    IMGLYRenderModeBackdrop = 1 << 8,
    /**
     *  Everything should be rendered.
     */
    IMGLYRenderModeAll = IMGLYRenderModeAutoEnhancement | IMGLYRenderModeOrientation | IMGLYRenderModeCrop |
    IMGLYRenderModeFocus | IMGLYRenderModePhotoEffect | IMGLYRenderModeColorAdjustments |
    IMGLYRenderModeOverlay | IMGLYRenderModeInset | IMGLYRenderModeBackdrop
};
