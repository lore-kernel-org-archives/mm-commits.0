From: akpm@linux-foundation.org
Subject: - maintainers-remove-hga-framebuffer-driver-entry.patch removed from -mm tree
Date: Wed, 15 Oct 2008 14:13:42 -0700
Message-ID: <200810152113.m9FLDgCc005607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753666AbYJOVYI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 17:24:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: remove HGA FRAMEBUFFER DRIVER entry
has been removed from the -mm tree.  Its filename was
     maintainers-remove-hga-framebuffer-driver-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: remove HGA FRAMEBUFFER DRIVER entry
From: Adrian Bunk <bunk@kernel.org>

- maintainer has not been active for years
- maintainer email bounces
- URL no longer exists
- covered by the FRAMEBUFFER LAYER entry

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 -------
 1 file changed, 7 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-hga-framebuffer-driver-entry MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-hga-framebuffer-driver-entry
+++ a/MAINTAINERS
@@ -1880,13 +1880,6 @@ M:	zippel@linux-m68k.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
-HGA FRAMEBUFFER DRIVER
-P:	Ferenc Bakonyi
-M:	fero@drama.obuda.kando.hu
-L:	linux-nvidia@lists.surfsouth.com
-W:	http://drama.obuda.kando.hu/~fero/cgi-bin/hgafb.shtml
-S:	Maintained
-
 HID CORE LAYER
 P:	Jiri Kosina
 M:	jkosina@suse.cz
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
the-overdue-eepro100-removal.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
asm-h8300-mdh-remove-cvs-keyword.patch
alpha-miata-remove-dead-url.patch
uml-remove-the-dead-tty_log-code.patch
include-linux-mounth-remove-cvs-keyword.patch
kernel-dmac-remove-a-cvs-keyword.patch
binfmt_somc-add-module_license.patch
make-probe_serial_gsc-static.patch
pnp-remove-printk-with-outdated-version.patch
telephony-remove-cvs-keywords.patch
reiserfs-procfsc-remove-cvs-keywords.patch
quota-remove-cvs-keywords.patch
make-ptrace_untrace-static.patch
fs-partitions-acornc-remove-dead-code.patch
parport-remove-cvs-keywords.patch
make-mm-rmapc-anon_vma_cachep-static.patch
ipc-semc-make-free_un-static.patch
make-hp_wmi_notify-static.patch
make-kprobesc-kretprobe_table_lock-static.patch
acpi-use-bcd2bin-bin2bcd.patch
alpha-use-bcd2bin-bin2bcd.patch
cris-use-bcd2bin-bin2bcd.patch
drivers-rtc-use-bcd2bin-bin2bcd.patch
rtc-use-bcd2bin-bin2bcd.patch
mips-use-bcd2bin-bin2bcd.patch
mn10300-use-bcd2bin-bin2bcd.patch
i2c-use-bcd2bin-bin2bcd.patch
drivers-scsi-sr_vendorc-use-bcd2bin.patch
remove-the-obsolete-bcdbin-binbcd-macros.patch
include-linux-bcdh-remove-comments.patch
reiser4.patch

