From: akpm@linux-foundation.org
Subject: - m68k-enable-config_compat_brk-by-default.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:47:28 -0700
Message-ID: <200806081947.m58JlSne017421@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755215AbYFHTrj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:47:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: enable CONFIG_COMPAT_BRK by default
has been removed from the -mm tree.  Its filename was
     m68k-enable-config_compat_brk-by-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k: enable CONFIG_COMPAT_BRK by default
From: Geert Uytterhoeven <geert@linux-m68k.org>

As some m68k machines have plenty of libc5 binaries in active use, enable
CONFIG_COMPAT_BRK by default.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/configs/amiga_defconfig    |    6 +++---
 arch/m68k/configs/apollo_defconfig   |    6 +++---
 arch/m68k/configs/atari_defconfig    |    6 +++---
 arch/m68k/configs/bvme6000_defconfig |    6 +++---
 arch/m68k/configs/hp300_defconfig    |    6 +++---
 arch/m68k/configs/mac_defconfig      |    6 +++---
 arch/m68k/configs/multi_defconfig    |    6 +++---
 arch/m68k/configs/mvme147_defconfig  |    6 +++---
 arch/m68k/configs/mvme16x_defconfig  |    6 +++---
 arch/m68k/configs/q40_defconfig      |    6 +++---
 arch/m68k/configs/sun3_defconfig     |    6 +++---
 arch/m68k/configs/sun3x_defconfig    |    6 +++---
 12 files changed, 36 insertions(+), 36 deletions(-)

diff -puN arch/m68k/configs/amiga_defconfig~m68k-enable-config_compat_brk-by-default arch/m68k/configs/amiga_defconfig
--- a/arch/m68k/configs/amiga_defconfig~m68k-enable-config_compat_brk-by-default
+++ a/arch/m68k/configs/amiga_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc2
-# Sun May 18 14:44:41 2008
+# Linux kernel version: 2.6.26-rc4
+# Wed May 28 22:47:35 2008
 #
 CONFIG_M68K=y
 CONFIG_MMU=y
@@ -59,7 +59,7 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-# CONFIG_COMPAT_BRK is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
diff -puN arch/m68k/configs/apollo_defconfig~m68k-enable-config_compat_brk-by-default arch/m68k/configs/apollo_defconfig
--- a/arch/m68k/configs/apollo_defconfig~m68k-enable-config_compat_brk-by-default
+++ a/arch/m68k/configs/apollo_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc2
-# Sun May 18 14:44:42 2008
+# Linux kernel version: 2.6.26-rc4
+# Wed May 28 22:47:35 2008
 #
 CONFIG_M68K=y
 CONFIG_MMU=y
@@ -59,7 +59,7 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-# CONFIG_COMPAT_BRK is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
diff -puN arch/m68k/configs/atari_defconfig~m68k-enable-config_compat_brk-by-default arch/m68k/configs/atari_defconfig
--- a/arch/m68k/configs/atari_defconfig~m68k-enable-config_compat_brk-by-default
+++ a/arch/m68k/configs/atari_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc2
-# Sun May 18 14:44:43 2008
+# Linux kernel version: 2.6.26-rc4
+# Wed May 28 22:47:35 2008
 #
 CONFIG_M68K=y
 CONFIG_MMU=y
@@ -59,7 +59,7 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-# CONFIG_COMPAT_BRK is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
diff -puN arch/m68k/configs/bvme6000_defconfig~m68k-enable-config_compat_brk-by-default arch/m68k/configs/bvme6000_defconfig
--- a/arch/m68k/configs/bvme6000_defconfig~m68k-enable-config_compat_brk-by-default
+++ a/arch/m68k/configs/bvme6000_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc2
-# Sun May 18 14:44:45 2008
+# Linux kernel version: 2.6.26-rc4
+# Wed May 28 22:47:35 2008
 #
 CONFIG_M68K=y
 CONFIG_MMU=y
@@ -59,7 +59,7 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-# CONFIG_COMPAT_BRK is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
diff -puN arch/m68k/configs/hp300_defconfig~m68k-enable-config_compat_brk-by-default arch/m68k/configs/hp300_defconfig
--- a/arch/m68k/configs/hp300_defconfig~m68k-enable-config_compat_brk-by-default
+++ a/arch/m68k/configs/hp300_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc2
-# Sun May 18 14:44:46 2008
+# Linux kernel version: 2.6.26-rc4
+# Wed May 28 22:47:35 2008
 #
 CONFIG_M68K=y
 CONFIG_MMU=y
@@ -59,7 +59,7 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-# CONFIG_COMPAT_BRK is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
diff -puN arch/m68k/configs/mac_defconfig~m68k-enable-config_compat_brk-by-default arch/m68k/configs/mac_defconfig
--- a/arch/m68k/configs/mac_defconfig~m68k-enable-config_compat_brk-by-default
+++ a/arch/m68k/configs/mac_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc2
-# Sun May 18 14:44:47 2008
+# Linux kernel version: 2.6.26-rc4
+# Wed May 28 22:47:35 2008
 #
 CONFIG_M68K=y
 CONFIG_MMU=y
@@ -59,7 +59,7 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-# CONFIG_COMPAT_BRK is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
diff -puN arch/m68k/configs/multi_defconfig~m68k-enable-config_compat_brk-by-default arch/m68k/configs/multi_defconfig
--- a/arch/m68k/configs/multi_defconfig~m68k-enable-config_compat_brk-by-default
+++ a/arch/m68k/configs/multi_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc2
-# Sun May 18 14:42:31 2008
+# Linux kernel version: 2.6.26-rc4
+# Wed May 28 22:47:35 2008
 #
 CONFIG_M68K=y
 CONFIG_MMU=y
@@ -59,7 +59,7 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-# CONFIG_COMPAT_BRK is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
diff -puN arch/m68k/configs/mvme147_defconfig~m68k-enable-config_compat_brk-by-default arch/m68k/configs/mvme147_defconfig
--- a/arch/m68k/configs/mvme147_defconfig~m68k-enable-config_compat_brk-by-default
+++ a/arch/m68k/configs/mvme147_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc2
-# Sun May 18 14:44:49 2008
+# Linux kernel version: 2.6.26-rc4
+# Wed May 28 22:47:35 2008
 #
 CONFIG_M68K=y
 CONFIG_MMU=y
@@ -59,7 +59,7 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-# CONFIG_COMPAT_BRK is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
diff -puN arch/m68k/configs/mvme16x_defconfig~m68k-enable-config_compat_brk-by-default arch/m68k/configs/mvme16x_defconfig
--- a/arch/m68k/configs/mvme16x_defconfig~m68k-enable-config_compat_brk-by-default
+++ a/arch/m68k/configs/mvme16x_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc2
-# Sun May 18 14:44:50 2008
+# Linux kernel version: 2.6.26-rc4
+# Wed May 28 22:47:35 2008
 #
 CONFIG_M68K=y
 CONFIG_MMU=y
@@ -59,7 +59,7 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-# CONFIG_COMPAT_BRK is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
diff -puN arch/m68k/configs/q40_defconfig~m68k-enable-config_compat_brk-by-default arch/m68k/configs/q40_defconfig
--- a/arch/m68k/configs/q40_defconfig~m68k-enable-config_compat_brk-by-default
+++ a/arch/m68k/configs/q40_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc2
-# Sun May 18 14:44:51 2008
+# Linux kernel version: 2.6.26-rc4
+# Wed May 28 22:47:35 2008
 #
 CONFIG_M68K=y
 CONFIG_MMU=y
@@ -59,7 +59,7 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-# CONFIG_COMPAT_BRK is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
diff -puN arch/m68k/configs/sun3_defconfig~m68k-enable-config_compat_brk-by-default arch/m68k/configs/sun3_defconfig
--- a/arch/m68k/configs/sun3_defconfig~m68k-enable-config_compat_brk-by-default
+++ a/arch/m68k/configs/sun3_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc2
-# Sun May 18 14:44:53 2008
+# Linux kernel version: 2.6.26-rc4
+# Wed May 28 22:47:35 2008
 #
 CONFIG_M68K=y
 CONFIG_MMU=y
@@ -59,7 +59,7 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-# CONFIG_COMPAT_BRK is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
diff -puN arch/m68k/configs/sun3x_defconfig~m68k-enable-config_compat_brk-by-default arch/m68k/configs/sun3x_defconfig
--- a/arch/m68k/configs/sun3x_defconfig~m68k-enable-config_compat_brk-by-default
+++ a/arch/m68k/configs/sun3x_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc2
-# Sun May 18 14:44:54 2008
+# Linux kernel version: 2.6.26-rc4
+# Wed May 28 22:47:35 2008
 #
 CONFIG_M68K=y
 CONFIG_MMU=y
@@ -59,7 +59,7 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-# CONFIG_COMPAT_BRK is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
zorro-use-memory_read_from_buffer.patch

