From: akpm@osdl.org
Subject: - alsa-add-struct-forward-declaration.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:18:36 -0800
Message-ID: <200612072318.kB7NIa8n031044@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54015 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163931AbWLGXSp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:18:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     ALSA: add struct forward declaration
has been removed from the -mm tree.  Its filename was
     alsa-add-struct-forward-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ALSA: add struct forward declaration
From: Randy Dunlap <randy.dunlap@oracle.com>

I see about 10 sets of these in a random config.

  CC      drivers/media/video/saa7134/saa7134-cards.o
In file included from drivers/media/video/saa7134/saa7134.h:43,
                 from drivers/media/video/saa7134/saa7134-cards.c:27:
include/sound/pcm.h:59: warning: 'struct snd_pcm_substream' declared inside parameter list
include/sound/pcm.h:59: warning: its scope is only this definition or declaration, which is probably not what you want
include/sound/pcm.h:60: warning: 'struct snd_pcm_substream' declared inside parameter list
include/sound/pcm.h:62: warning: 'struct snd_pcm_substream' declared inside parameter list
include/sound/pcm.h:64: warning: 'struct snd_pcm_substream' declared inside parameter list
include/sound/pcm.h:65: warning: 'struct snd_pcm_substream' declared inside parameter list
include/sound/pcm.h:66: warning: 'struct snd_pcm_substream' declared inside parameter list
include/sound/pcm.h:67: warning: 'struct snd_pcm_substream' declared inside parameter list
include/sound/pcm.h:68: warning: 'struct snd_pcm_substream' declared inside parameter list
include/sound/pcm.h:71: warning: 'struct snd_pcm_substream' declared inside parameter list
include/sound/pcm.h:73: warning: 'struct snd_pcm_substream' declared inside parameter list
include/sound/pcm.h:75: warning: 'struct snd_pcm_substream' declared inside parameter list
include/sound/pcm.h:76: warning: 'struct snd_pcm_substream' declared inside parameter list
include/sound/pcm.h:77: warning: 'struct snd_pcm_substream' declared inside parameter list

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/sound/pcm.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/sound/pcm.h~alsa-add-struct-forward-declaration include/sound/pcm.h
--- a/include/sound/pcm.h~alsa-add-struct-forward-declaration
+++ a/include/sound/pcm.h
@@ -55,6 +55,8 @@ struct snd_pcm_hardware {
 	size_t fifo_size;		/* fifo size in bytes */
 };
 
+struct snd_pcm_substream;
+
 struct snd_pcm_ops {
 	int (*open)(struct snd_pcm_substream *substream);
 	int (*close)(struct snd_pcm_substream *substream);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-ieee1394.patch
git-input.patch
git-mtd.patch
mtd-esb2rom-uses-pci.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
generic-bug-implementation-handle-bug=n.patch
reiser4-use-null-for-pointers.patch
visws-sgivwfb-is-module-needs-exports.patch
linux-fbdev-devel-is-subscribers-only.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
profile_likely-export-do_check_likely.patch

