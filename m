From: akpm@linux-foundation.org
Subject: - clean-up-duplicate-includes-in-sound-soc.patch removed from -mm tree
Date: Mon, 23 Jul 2007 23:04:41 -0700
Message-ID: <200707240604.l6O64fK6031432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57299 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753543AbXGXGEy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 02:04:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, rpurdie@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     Clean up duplicate includes in sound/soc/
has been removed from the -mm tree.  Its filename was
     clean-up-duplicate-includes-in-sound-soc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Clean up duplicate includes in sound/soc/
From: Jesper Juhl <jesper.juhl@gmail.com>

This patch cleans up duplicate includes in
	sound/soc/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Richard Purdie <rpurdie@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/soc/pxa/spitz.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN sound/soc/pxa/spitz.c~clean-up-duplicate-includes-in-sound-soc sound/soc/pxa/spitz.c
--- a/sound/soc/pxa/spitz.c~clean-up-duplicate-includes-in-sound-soc
+++ a/sound/soc/pxa/spitz.c
@@ -34,7 +34,6 @@
 #include <asm/arch/hardware.h>
 #include <asm/arch/akita.h>
 #include <asm/arch/spitz.h>
-#include <asm/mach-types.h>
 #include "../codecs/wm8750.h"
 #include "pxa2xx-pcm.h"
 #include "pxa2xx-i2s.h"
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

git-alsa.patch
clean-up-duplicate-includes-in-sound-ppc.patch
git-agpgart.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
git-dvb.patch
clean-up-duplicate-includes-in-drivers-hwmon.patch
git-gfs2-nmw.patch
hid-fix-a-null-pointer-dereference-when-we-fail-to-allocate-memory.patch
clean-up-duplicate-includes-in-drivers-input.patch
git-kbuild.patch
git-mtd.patch
clean-up-duplicate-includes-in-drivers-net.patch
clean-up-duplicate-includes-in-drivers-atm.patch
clean-up-duplicate-includes-in-net-atm.patch
clean-up-duplicate-includes-in-net-bridge.patch
clean-up-duplicate-includes-in-net-ipv4.patch
clean-up-duplicate-includes-in-net-ipv6.patch
clean-up-duplicate-includes-in-net-netfilter.patch
clean-up-duplicate-includes-in-net-sched.patch
clean-up-duplicate-includes-in-net-sunrpc.patch
clean-up-duplicate-includes-in-net-tipc.patch
clean-up-duplicate-includes-in-net-xfrm.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
git-selinux.patch
clean-up-duplicate-includes-in-drivers-scsi.patch
clean-up-duplicate-includes-in-drivers-block.patch
clean-up-duplicate-includes-in-drivers-usb.patch
clean-up-duplicate-includes-in-arch-i386-xen.patch
git-xfs.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
ipmi-fix-mem-leak-in-try_init_dmi.patch
fix-a-use-after-free-bug-in-kernel-userspace-relay-file-support.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
cciss-fix-memory-leak.patch
clean-up-duplicate-includes-in-drivers-spi.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
