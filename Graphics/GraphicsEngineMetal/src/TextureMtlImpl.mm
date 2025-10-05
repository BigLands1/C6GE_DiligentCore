/*
 *  Copyright 2019-2025 Diligent Graphics LLC
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *  In no event and under no legal theory, whether in tort (including negligence),
 *  contract, or otherwise, unless required by applicable law (such as deliberate
 *  and grossly negligent acts) or agreed to in writing, shall any Contributor be
 *  liable for any damages, including any direct, indirect, special, incidental,
 *  or consequential damages of any character arising as a result of this License or
 *  out of the use or inability to use the software (including but not limited to damages
 *  for loss of goodwill, work stoppage, computer failure or malfunction, or any and
 *  all other commercial damages or losses), even if such Contributor has been advised
 *  of the possibility of such damages.
 */

#include "TextureMtlImpl.hpp"
#include "RenderDeviceMtlImpl.hpp"
#include "Cast.hpp"
#import <Metal/Metal.h>

namespace Diligent
{

static MTLPixelFormat GetMtlPixelFormat(TEXTURE_FORMAT Format)
{
    switch (Format)
    {
        case TEX_FORMAT_RGBA8_UNORM: return MTLPixelFormatRGBA8Unorm;
        case TEX_FORMAT_BGRA8_UNORM: return MTLPixelFormatBGRA8Unorm;
        case TEX_FORMAT_R32_FLOAT: return MTLPixelFormatR32Float;
        case TEX_FORMAT_RG32_FLOAT: return MTLPixelFormatRG32Float;
        case TEX_FORMAT_RGBA32_FLOAT: return MTLPixelFormatRGBA32Float;
        case TEX_FORMAT_D32_FLOAT: return MTLPixelFormatDepth32Float;
        // Add more formats as needed
        default: return MTLPixelFormatInvalid;
    }
}

TextureMtlImpl::TextureMtlImpl(IReferenceCounters*        pRefCounters,
                               FixedBlockMemoryAllocator& TexViewObjMemAllocator,
                               RenderDeviceMtlImpl*       pDeviceMtl,
                               const TextureDesc&         TexDesc,
                               const TextureData*         pData) :
    TTextureBase{pRefCounters, TexViewObjMemAllocator, pDeviceMtl, TexDesc}
{
    @autoreleasepool
    {
        id<MTLDevice> mtlDevice = pDeviceMtl->GetMtlDevice();
        
        MTLTextureDescriptor* texDesc = [[MTLTextureDescriptor alloc] init];
        
        switch (TexDesc.Type)
        {
            case RESOURCE_DIM_TEX_2D:
                texDesc.textureType = MTLTextureType2D;
                break;
            case RESOURCE_DIM_TEX_CUBE:
                texDesc.textureType = MTLTextureTypeCube;
                break;
            case RESOURCE_DIM_TEX_3D:
                texDesc.textureType = MTLTextureType3D;
                break;
            default:
                texDesc.textureType = MTLTextureType2D;
                break;
        }
        
        texDesc.pixelFormat = GetMtlPixelFormat(TexDesc.Format);
        texDesc.width = TexDesc.Width;
        texDesc.height = TexDesc.Height;
        texDesc.depth = TexDesc.Depth;
        texDesc.mipmapLevelCount = TexDesc.MipLevels;
        texDesc.arrayLength = TexDesc.ArraySize;
        texDesc.usage = MTLTextureUsageShaderRead | MTLTextureUsageRenderTarget;
        
        m_MtlTexture = [mtlDevice newTextureWithDescriptor:texDesc];
        [texDesc release];
        
        if (m_MtlTexture == nil)
        {
            LOG_ERROR_AND_THROW("Failed to create Metal texture");
        }
        
        // Upload initial data if provided
        if (pData != nullptr && pData->pSubResources != nullptr)
        {
            for (Uint32 mip = 0; mip < TexDesc.MipLevels; ++mip)
            {
                for (Uint32 slice = 0; slice < TexDesc.ArraySize; ++slice)
                {
                    Uint32 subresIdx = mip + slice * TexDesc.MipLevels;
                    const auto& subres = pData->pSubResources[subresIdx];
                    
                    if (subres.pData != nullptr)
                    {
                        MTLRegion region = MTLRegionMake2D(0, 0, 
                                                          std::max(1u, TexDesc.Width >> mip),
                                                          std::max(1u, TexDesc.Height >> mip));
                        
                        [m_MtlTexture replaceRegion:region
                                        mipmapLevel:mip
                                              slice:slice
                                          withBytes:subres.pData
                                        bytesPerRow:subres.Stride
                                      bytesPerImage:subres.DepthStride];
                    }
                }
            }
        }
    }
}

TextureMtlImpl::TextureMtlImpl(IReferenceCounters*        pRefCounters,
                               FixedBlockMemoryAllocator& TexViewObjMemAllocator,
                               RenderDeviceMtlImpl*       pDeviceMtl,
                               const TextureDesc&         TexDesc,
                               RESOURCE_STATE             InitialState,
                               id<MTLTexture>             mtlTexture) :
    TTextureBase{pRefCounters, TexViewObjMemAllocator, pDeviceMtl, TexDesc},
    m_MtlTexture{mtlTexture}
{
    if (m_MtlTexture != nil)
    {
        [m_MtlTexture retain];
    }
}

TextureMtlImpl::~TextureMtlImpl()
{
    if (m_MtlTexture != nil)
    {
        [m_MtlTexture release];
        m_MtlTexture = nil;
    }
}

id<MTLResource> TextureMtlImpl::GetMtlResource() const
{
    return m_MtlTexture;
}

id<MTLHeap> TextureMtlImpl::GetMtlHeap() const
{
    return m_MtlTexture != nil ? [m_MtlTexture heap] : nil;
}

Uint64 TextureMtlImpl::GetNativeHandle()
{
    return BitCast<Uint64>(m_MtlTexture);
}

} // namespace Diligent
