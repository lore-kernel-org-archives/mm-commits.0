From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-sound-soc-intel-patterns.patch
 removed from -mm tree
Date: Mon, 06 Jul 2015 12:48:03 -0700
Message-ID: <559adb73.3d+5TMkisdf0YuS1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59653 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791AbbGFTsD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:48:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, yang.jie@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update sound soc intel patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-sound-soc-intel-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update sound soc intel patterns

commit 2106241a6803 ("ASoC: Intel: create common folder and move common
files in") moved the files around.  Update the patterns.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jie Yang <yang.jie@intel.com>
Acked-by: Jie Yang <yang.jie@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN MAINTAINERS~maintainers-update-sound-soc-intel-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-sound-soc-intel-patterns
+++ a/MAINTAINERS
@@ -5285,11 +5285,10 @@ INTEL ASoC BDW/HSW DRIVERS
 M:	Jie Yang <yang.jie@linux.intel.com>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 S:	Supported
-F:	sound/soc/intel/sst-haswell*
-F:	sound/soc/intel/sst-dsp*
-F:	sound/soc/intel/sst-firmware.c
-F:	sound/soc/intel/broadwell.c
-F:	sound/soc/intel/haswell.c
+F:	sound/soc/intel/common/sst-dsp*
+F:	sound/soc/intel/common/sst-firmware.c
+F:	sound/soc/intel/boards/broadwell.c
+F:	sound/soc/intel/haswell/
 
 INTEL C600 SERIES SAS CONTROLLER DRIVER
 M:	Intel SCU Linux support <intel-linux-scu@intel.com>
_

Patches currently in -mm which might be from joe@perches.com are

ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

