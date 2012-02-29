From: akpm@linux-foundation.org
Subject: + maintainers-add-s-maintained-to-clkdev-and-clk-sections.patch added to -mm tree
Date: Wed, 29 Feb 2012 14:32:40 -0800
Message-ID: <20120229223240.8D4D9A0476@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:39409 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353Ab2B2Wcm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Feb 2012 17:32:42 -0500
Received: by wibhm11 with SMTP id hm11so163469wib.1
        for <mm-commits@vger.kernel.org>; Wed, 29 Feb 2012 14:32:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, linux@arm.linux.org.uk


The patch titled
     Subject: MAINTAINERS: Add "S: Maintained" to clkdev and clk sections
has been added to the -mm tree.  Its filename is
     maintainers-add-s-maintained-to-clkdev-and-clk-sections.patch

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
Subject: MAINTAINERS: Add "S: Maintained" to clkdev and clk sections

Russell King seems to be maintaining these.  Might as well mark them with
the appropriate S: entry

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff -puN MAINTAINERS~maintainers-add-s-maintained-to-clkdev-and-clk-sections MAINTAINERS
--- a/MAINTAINERS~maintainers-add-s-maintained-to-clkdev-and-clk-sections
+++ a/MAINTAINERS
@@ -715,6 +715,7 @@ S:	Maintained
 ARM/CLKDEV SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
 F:	arch/arm/include/asm/clkdev.h
 F:	drivers/clk/clkdev.c
 
@@ -1821,6 +1822,7 @@ F:	sound/soc/codecs/cs4270*
 
 CLK API
 M:	Russell King <linux@arm.linux.org.uk>
+S:	Maintained
 F:	include/linux/clk.h
 
 CISCO FCOE HBA DRIVER
_
Subject: Subject: MAINTAINERS: Add "S: Maintained" to clkdev and clk sections

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
thermal_sys-remove-unnecessary-line-continuations.patch
thermal_sys-remove-obfuscating-used-once-macros.patch
thermal_sys-kernel-style-cleanups.patch
thermal_sys-convert-printks-to-pr_level.patch
get_maintainer-use-a-default-unknown-s-status-role.patch
maintainers-fix-remoteproc-f-typo.patch
maintainers-update-mca-section.patch
maintainers-update-git-urls-for-26-deletions.patch
maintainers-add-status-to-alpha-architecture.patch
maintainers-add-s-maintained-to-clkdev-and-clk-sections.patch
include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf.patch
checkpatch-add-some-strict-coding-style-checks.patch
checkpatchpl-be-silent-when-q-and-ignore-is-given.patch

