From: akpm@linux-foundation.org
Subject: [merged] sound-soc-atmel-atmel-pcmc-fix-warning.patch removed
 from -mm tree
Date: Mon, 30 Sep 2013 11:57:30 -0700
Message-ID: <5249c99a.KhCyUtrAiI5uQyk5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660Ab3I3S5b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Sep 2013 14:57:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tiwai@suse.de, perex@perex.cz, lgirdwood@gmail.com, broonie@kernel.org, akpm@linux-foundation.org

Subject: [merged] sound-soc-atmel-atmel-pcmc-fix-warning.patch removed from -mm tree
To: akpm@linux-foundation.org,broonie@kernel.org,lgirdwood@gmail.com,perex@perex.cz,tiwai@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 30 Sep 2013 11:57:30 -0700


The patch titled
     Subject: sound/soc/atmel/atmel-pcm.c: fix warning
has been removed from the -mm tree.  Its filename was
     sound-soc-atmel-atmel-pcmc-fix-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sound/soc/atmel/atmel-pcm.c: fix warning

i386 allmodconfig:

sound/soc/atmel/atmel-pcm.c: In function 'atmel_pcm_preallocate_dma_buffer':
sound/soc/atmel/atmel-pcm.c:52: warning: cast to pointer from integer of different size

Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/soc/atmel/atmel-pcm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN sound/soc/atmel/atmel-pcm.c~sound-soc-atmel-atmel-pcmc-fix-warning sound/soc/atmel/atmel-pcm.c
--- a/sound/soc/atmel/atmel-pcm.c~sound-soc-atmel-atmel-pcmc-fix-warning
+++ a/sound/soc/atmel/atmel-pcm.c
@@ -50,7 +50,7 @@ static int atmel_pcm_preallocate_dma_buf
 	buf->area = dma_alloc_coherent(pcm->card->dev, size,
 			&buf->addr, GFP_KERNEL);
 	pr_debug("atmel-pcm: alloc dma buffer: area=%p, addr=%p, size=%zu\n",
-			(void *)buf->area, (void *)buf->addr, size);
+			(void *)buf->area, (void *)(long)buf->addr, size);
 
 	if (!buf->area)
 		return -ENOMEM;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix-fix.patch
include-asm-generic-vtimeh-avoid-zero-length-file.patch
mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists-fix.patch
ipc-semc-update-sem_otime-for-all-operations-checkpatch-fixes.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
memblock-factor-out-of-top-down-allocation-hack.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

