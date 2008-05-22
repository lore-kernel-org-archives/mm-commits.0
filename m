From: akpm@linux-foundation.org
Subject: + remove-some-more-tipar-bits.patch added to -mm tree
Date: Wed, 21 May 2008 23:17:08 -0700
Message-ID: <200805220617.m4M6H8ZE020585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751711AbYEVGRX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 02:17:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org


The patch titled
     remove some more tipar bits
has been added to the -mm tree.  Its filename is
     remove-some-more-tipar-bits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove some more tipar bits
From: Adrian Bunk <bunk@kernel.org>

Some bits were missed when the tipar driver was removed.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/00-INDEX              |    2 --
 Documentation/kernel-parameters.txt |    7 -------
 drivers/char/Makefile               |    1 -
 3 files changed, 10 deletions(-)

diff -puN Documentation/00-INDEX~remove-some-more-tipar-bits Documentation/00-INDEX
--- a/Documentation/00-INDEX~remove-some-more-tipar-bits
+++ a/Documentation/00-INDEX
@@ -359,8 +359,6 @@ telephony/
 	- directory with info on telephony (e.g. voice over IP) support.
 time_interpolators.txt
 	- info on time interpolators.
-tipar.txt
-	- information about Parallel link cable for Texas Instruments handhelds.
 tty.txt
 	- guide to the locking policies of the tty layer.
 uml/
diff -puN Documentation/kernel-parameters.txt~remove-some-more-tipar-bits Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~remove-some-more-tipar-bits
+++ a/Documentation/kernel-parameters.txt
@@ -2093,13 +2093,6 @@ and is between 256 and 4096 characters. 
 			<deci-seconds>: poll all this frequency
 			0: no polling (default)
 
-	tipar.timeout=	[HW,PPT]
-			Set communications timeout in tenths of a second
-			(default 15).
-
-	tipar.delay=	[HW,PPT]
-			Set inter-bit delay in microseconds (default 10).
-
 	tmscsim=	[HW,SCSI]
 			See comment before function dc390_setup() in
 			drivers/scsi/tmscsim.c.
diff -puN drivers/char/Makefile~remove-some-more-tipar-bits drivers/char/Makefile
--- a/drivers/char/Makefile~remove-some-more-tipar-bits
+++ a/drivers/char/Makefile
@@ -62,7 +62,6 @@ obj-$(CONFIG_BRIQ_PANEL)	+= briq_panel.o
 obj-$(CONFIG_BFIN_OTP)		+= bfin-otp.o
 
 obj-$(CONFIG_PRINTER)		+= lp.o
-obj-$(CONFIG_TIPAR)		+= tipar.o
 
 obj-$(CONFIG_APM_EMULATION)	+= apm-emulation.o
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
ibmaem-fix-64-bit-division-on-32-bit-platforms-update.patch
md-proper-extern-for-mdp_major.patch
linux-next.patch
proper-prototype-for-acpi_processor_tstate_has_changed.patch
remove-drivers-acorn-char-defkeymap-l7200c.patch
drm-make-drm_minors_cleanup-static.patch
if-0-ses_match_host.patch
git-watchdog.patch
git-xtensa.patch
mm-migratec-should-include-linux-syscallsh.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
remove-include-asm-h8300-keyboardh.patch
remove-the-v850-port.patch
init-do_mountsc-should-include-linux-initrdh.patch
proper-spawn_ksoftirqd-prototype.patch
build-kernel-profileo-only-when-requested.patch
build-kernel-profileo-only-when-requested-cleanups.patch
asm-generic-int-ll64h-always-provide-__su64.patch
remove-some-more-tipar-bits.patch
remove-the-oss-trident-driver.patch
serial-8250_gscc-add-module_license.patch
mfd-sm501c-if-0-unused-functions.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
video-sis-remove-compat-code.patch
minix-remove-no_truncate-code.patch
remove-is_tty.patch
proper-extern-for-mwave_s_mdd.patch
if-0-hpet_unregister.patch
unexport-proc_clear_tty.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proper-pidhashmap_init-prototypes.patch
unexport-uts_sem.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
make-cgroup_seqfile_release-static.patch
make-kprobe_blacklist-static.patch
make-pnp_add_card_id-static.patch
make-struct-mpt_proc_root_dir-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
reiser4.patch
config_sound_wm97xx-remove-stale-makefile-line.patch
run-all-userspace-headers-through-unifdef.patch

