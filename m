From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 04 Aug 2017 14:17:47 -0700
Message-ID: <20170804211747.1_d6pIrBd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51688 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751312AbdHDVRs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2017 17:17:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c~linux-next-git-rejects sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c
--- a/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c~linux-next-git-rejects
+++ a/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c
@@ -355,10 +355,6 @@ static int kabylake_ssp0_hw_params(struc
 
 			ret = snd_soc_dai_set_sysclk(codec_dai,
 				RT5514_SCLK_S_MCLK, 24576000, SND_SOC_CLOCK_IN);
-<<<<<<< HEAD
-			if (ret < 0) {
-				dev_err(rtd->dev, "set sysclk err: %d\n", ret);
-=======
 			if (ret < 0) {
 				dev_err(rtd->dev, "set sysclk err: %d\n", ret);
 				return ret;
@@ -368,7 +364,6 @@ static int kabylake_ssp0_hw_params(struc
 			ret = snd_soc_dai_set_tdm_slot(codec_dai, 0x30, 3, 8, 16);
 			if (ret < 0) {
 				dev_err(rtd->dev, "DEV0 TDM slot err:%d\n", ret);
->>>>>>> linux-next/akpm-base
 				return ret;
 			}
 		}
diff -puN sound/soc/intel/skylake/skl.c~linux-next-git-rejects sound/soc/intel/skylake/skl.c
--- a/sound/soc/intel/skylake/skl.c~linux-next-git-rejects
+++ a/sound/soc/intel/skylake/skl.c
@@ -996,8 +996,6 @@ static struct sst_acpi_mach sst_glk_devd
 		.fw_filename = "intel/dsp_fw_glk.bin",
 	},
 	{}
-<<<<<<< HEAD
-=======
 };
 
 static const struct sst_acpi_mach sst_cnl_devdata[] = {
@@ -1006,7 +1004,6 @@ static const struct sst_acpi_mach sst_cn
 		.drv_name = "cnl_rt274",
 		.fw_filename = "intel/dsp_fw_cnl.bin",
 	},
->>>>>>> linux-next/akpm-base
 };
 
 /* PCI IDs */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-make-tlb_flush_pending-global-fix.patch
mm-oom-task_will_free_memcurrent-should-ignore-mmf_oom_skip-for-once-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch
add-testcases-for-memset16-32-64-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

