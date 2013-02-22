From: akpm@linux-foundation.org
Subject: [merged] decompressors-drop-dependency-on-config_expert.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:42:39 -0800
Message-ID: <20130222204239.9DEA65A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:64316 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab3BVUmk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:42:40 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so103888ghb.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:42:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: florian@openwrt.org, lasse.collin@tukaani.org, mm-commits@vger.kernel.org


The patch titled
     Subject: decompressors: drop dependency on CONFIG_EXPERT
has been removed from the -mm tree.  Its filename was
     decompressors-drop-dependency-on-config_expert.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Florian Fainelli <florian@openwrt.org>
Subject: decompressors: drop dependency on CONFIG_EXPERT

Remove the XZ_DEC_* depedencey on CONFIG_EXPERT as recommended by Lasse
Colin.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Acked-by: Lasse Collin <lasse.collin@tukaani.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xz/Kconfig |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN lib/xz/Kconfig~decompressors-drop-dependency-on-config_expert lib/xz/Kconfig
--- a/lib/xz/Kconfig~decompressors-drop-dependency-on-config_expert
+++ a/lib/xz/Kconfig
@@ -9,32 +9,32 @@ config XZ_DEC
 if XZ_DEC
 
 config XZ_DEC_X86
-	bool "x86 BCJ filter decoder" if EXPERT
+	bool "x86 BCJ filter decoder"
 	default y
 	select XZ_DEC_BCJ
 
 config XZ_DEC_POWERPC
-	bool "PowerPC BCJ filter decoder" if EXPERT
+	bool "PowerPC BCJ filter decoder"
 	default y
 	select XZ_DEC_BCJ
 
 config XZ_DEC_IA64
-	bool "IA-64 BCJ filter decoder" if EXPERT
+	bool "IA-64 BCJ filter decoder"
 	default y
 	select XZ_DEC_BCJ
 
 config XZ_DEC_ARM
-	bool "ARM BCJ filter decoder" if EXPERT
+	bool "ARM BCJ filter decoder"
 	default y
 	select XZ_DEC_BCJ
 
 config XZ_DEC_ARMTHUMB
-	bool "ARM-Thumb BCJ filter decoder" if EXPERT
+	bool "ARM-Thumb BCJ filter decoder"
 	default y
 	select XZ_DEC_BCJ
 
 config XZ_DEC_SPARC
-	bool "SPARC BCJ filter decoder" if EXPERT
+	bool "SPARC BCJ filter decoder"
 	default y
 	select XZ_DEC_BCJ
 
_

Patches currently in -mm which might be from florian@openwrt.org are

origin.patch
linux-next.patch

