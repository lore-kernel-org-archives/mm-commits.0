From: akpm@osdl.org
Subject: - video-pm3fb-macros-fix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:14:57 -0800
Message-ID: <200612082014.kB8KEvaK003229@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59895 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946990AbWLHUPB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:15:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     video: pm3fb macros fix
has been removed from the -mm tree.  Its filename was
     video-pm3fb-macros-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: video: pm3fb macros fix
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/video/pm3fb.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN include/video/pm3fb.h~video-pm3fb-macros-fix include/video/pm3fb.h
--- a/include/video/pm3fb.h~video-pm3fb-macros-fix
+++ a/include/video/pm3fb.h
@@ -607,16 +607,16 @@
 #define PM3FBDestReadModeOr					0xac98
 	#define PM3FBDestReadMode_ReadDisable			0<<0
 	#define PM3FBDestReadMode_ReadEnable			1<<0
-	#define PM3FBDestReadMode_StripePitch(sp)	(((sp)&0x7)<<2
-	#define PM3FBDestReadMode_StripeHeight(sh)	(((sh)&0x7)<<7
+	#define PM3FBDestReadMode_StripePitch(sp)	(((sp)&0x7)<<2)
+	#define PM3FBDestReadMode_StripeHeight(sh)	(((sh)&0x7)<<7)
 	#define PM3FBDestReadMode_Enable0			1<<8
 	#define PM3FBDestReadMode_Enable1			1<<9
 	#define PM3FBDestReadMode_Enable2			1<<10
 	#define PM3FBDestReadMode_Enable3			1<<11
-	#define PM3FBDestReadMode_Layout0(l)		(((l)&0x3)<<12
-	#define PM3FBDestReadMode_Layout1(l)		(((l)&0x3)<<14
-	#define PM3FBDestReadMode_Layout2(l)		(((l)&0x3)<<16
-	#define PM3FBDestReadMode_Layout3(l)		(((l)&0x3)<<18
+	#define PM3FBDestReadMode_Layout0(l)		(((l)&0x3)<<12)
+	#define PM3FBDestReadMode_Layout1(l)		(((l)&0x3)<<14)
+	#define PM3FBDestReadMode_Layout2(l)		(((l)&0x3)<<16)
+	#define PM3FBDestReadMode_Layout3(l)		(((l)&0x3)<<18)
 	#define PM3FBDestReadMode_Origin0			1<<20
 	#define PM3FBDestReadMode_Origin1			1<<21
 	#define PM3FBDestReadMode_Origin2			1<<22
@@ -640,16 +640,16 @@
 #define PM3FBSourceReadModeOr					0xaca8
 	#define PM3FBSourceReadMode_ReadDisable			(0<<0)
 	#define PM3FBSourceReadMode_ReadEnable			(1<<0)
-	#define PM3FBSourceReadMode_StripePitch(sp)	(((sp)&0x7)<<2
-	#define PM3FBSourceReadMode_StripeHeight(sh)	(((sh)&0x7)<<7
-	#define PM3FBSourceReadMode_Layout(l)		(((l)&0x3)<<8
+	#define PM3FBSourceReadMode_StripePitch(sp)	(((sp)&0x7)<<2)
+	#define PM3FBSourceReadMode_StripeHeight(sh)	(((sh)&0x7)<<7)
+	#define PM3FBSourceReadMode_Layout(l)		(((l)&0x3)<<8)
 	#define PM3FBSourceReadMode_Origin			1<<10
 	#define PM3FBSourceReadMode_Blocking			1<<11
 	#define PM3FBSourceReadMode_UserTexelCoord		1<<13
 	#define PM3FBSourceReadMode_WrapXEnable			1<<14
 	#define PM3FBSourceReadMode_WrapYEnable			1<<15
-	#define PM3FBSourceReadMode_WrapX(w)		(((w)&0xf)<<16
-	#define PM3FBSourceReadMode_WrapY(w)		(((w)&0xf)<<20
+	#define PM3FBSourceReadMode_WrapX(w)		(((w)&0xf)<<16)
+	#define PM3FBSourceReadMode_WrapY(w)		(((w)&0xf)<<20)
 	#define PM3FBSourceReadMode_ExternalSourceData		1<<24
 #define PM3FBWriteBufferAddr0                                   0xb000
 #define PM3FBWriteBufferAddr1                                   0xb008
@@ -942,7 +942,7 @@
 #define PM3Window						0x8980
 	#define PM3Window_ForceLBUpdate				1<<3
 	#define PM3Window_LBUpdateSource			1<<4
-	#define PM3Window_FrameCount(c)				(((c)&0xff)<<9
+	#define PM3Window_FrameCount(c)				(((c)&0xff)<<9)
 	#define PM3Window_StencilFCP				1<<17
 	#define PM3Window_DepthFCP				1<<18
 	#define PM3Window_OverrideWriteFiltering		1<<19
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
video-pm3fb-macros-fix.patch
ppc-cs4218_tdm-remove-extra-brace.patch
mips-dbg_io-stray-brackets-fix.patch
git-mtd.patch
scsi-sic7xxx-stray-bracket-fix.patch
scsi-53c7xx-brackets-fix.patch
sparc64-dma-remove-extra-brackets.patch

