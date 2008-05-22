From: akpm@linux-foundation.org
Subject: + config_sound_wm97xx-remove-stale-makefile-line.patch added to -mm tree
Date: Wed, 21 May 2008 23:18:04 -0700
Message-ID: <200805220618.m4M6I47o020704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751944AbYEVGST (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 02:18:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, rpjday@crashcourse.ca


The patch titled
     CONFIG_SOUND_WM97XX: remove stale makefile line
has been added to the -mm tree.  Its filename is
     config_sound_wm97xx-remove-stale-makefile-line.patch

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
Subject: CONFIG_SOUND_WM97XX: remove stale makefile line
From: Adrian Bunk <bunk@kernel.org>

The driver is gone for a long time.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/Makefile |    2 --
 1 file changed, 2 deletions(-)

diff -puN sound/oss/Makefile~config_sound_wm97xx-remove-stale-makefile-line sound/oss/Makefile
--- a/sound/oss/Makefile~config_sound_wm97xx-remove-stale-makefile-line
+++ a/sound/oss/Makefile
@@ -32,8 +32,6 @@ obj-$(CONFIG_SOUND_AU1550_AC97)	+= au155
 obj-$(CONFIG_SOUND_TRIDENT)	+= trident.o ac97_codec.o
 obj-$(CONFIG_SOUND_BCM_CS4297A)	+= swarm_cs4297a.o
 
-obj-$(CONFIG_SOUND_WM97XX)	+= ac97_plugin_wm97xx.o
-
 obj-$(CONFIG_DMASOUND)		+= dmasound/
 
 # Declare multi-part drivers.
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
config_sound_wm97xx-remove-stale-makefile-line.patch
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
run-all-userspace-headers-through-unifdef.patch

