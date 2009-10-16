From: akpm@linux-foundation.org
Subject: + dontdiff-ignore-files-nclude-generated-kernelarchcross.patch added to -mm tree
Date: Fri, 16 Oct 2009 15:23:09 -0700
Message-ID: <200910162223.n9GMN96b006541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750938AbZJPWXT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Oct 2009 18:23:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@simtec.co.uk, sam@ravnborg.org


The patch titled
     dontdiff: ignore files nclude/generated/kernel.{arch,cross}
has been added to the -mm tree.  Its filename is
     dontdiff-ignore-files-nclude-generated-kernelarchcross.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dontdiff: ignore files nclude/generated/kernel.{arch,cross}
From: Ben Dooks <ben@simtec.co.uk>

The files nclude/generated/kernel.arch and nclude/generated/kernel.cross
should not be appearing in diffs, so add them to Documentation/dontdiff

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/dontdiff~dontdiff-ignore-files-nclude-generated-kernelarchcross Documentation/dontdiff
--- a/Documentation/dontdiff~dontdiff-ignore-files-nclude-generated-kernelarchcross
+++ a/Documentation/dontdiff
@@ -109,6 +109,8 @@ initramfs_data.cpio.gz
 initramfs_list
 kallsyms
 kconfig
+kernel.arch
+kernel.cross
 keywords.c
 ksym.c*
 ksym.h*
_

Patches currently in -mm which might be from ben@simtec.co.uk are

dontdiff-ignore-files-nclude-generated-kernelarchcross.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch

