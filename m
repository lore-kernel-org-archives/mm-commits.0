From: akpm@linux-foundation.org
Subject: + maintainers-update-sound-soc-intel-patterns.patch added to -mm
 tree
Date: Tue, 05 May 2015 13:55:26 -0700
Message-ID: <55492e3e.ySkTLLcKecQ7TwCI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33288 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031448AbbEEUz1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2015 16:55:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, yang.jie@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update sound soc intel patterns
has been added to the -mm tree.  Its filename is
     maintainers-update-sound-soc-intel-patterns.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-sound-soc-intel-patterns.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-sound-soc-intel-patterns.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update sound soc intel patterns

commit 2106241a6803 ("ASoC: Intel: create common folder and move common
files in") moved the files around.  Update the patterns.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jie Yang <yang.jie@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN MAINTAINERS~maintainers-update-sound-soc-intel-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-sound-soc-intel-patterns
+++ a/MAINTAINERS
@@ -5088,11 +5088,10 @@ INTEL ASoC BDW/HSW DRIVERS
 M:	Jie Yang <yang.jie@linux.intel.com>
 L:	alsa-devel@alsa-project.org
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

compiler-gcch-neatening.patch
compiler-gcc-integrate-the-various-compiler-gcch-files.patch
kasan-show-gcc-version-requirements-in-kconfig-and-documentation.patch
ocfs2-reduce-object-size-of-mlog-uses.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
get_maintainerpl-add-get_maintainerignore-file-capability.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-remove-section-broadcom-bcm33xx-mips-architecture.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch

