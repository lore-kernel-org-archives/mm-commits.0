From: akpm@linux-foundation.org
Subject: [obsolete] dontdiff-ignore-files-nclude-generated-kernelarchcross.patch removed from -mm tree
Date: Wed, 28 Oct 2009 14:11:37 -0700
Message-ID: <200910282111.n9SLBbRX017382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755186AbZJ1VLp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Oct 2009 17:11:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@simtec.co.uk, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     dontdiff: ignore files nclude/generated/kernel.{arch,cross}
has been removed from the -mm tree.  Its filename was
     dontdiff-ignore-files-nclude-generated-kernelarchcross.patch

This patch was dropped because it is obsolete

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
@@ -110,6 +110,8 @@ initramfs_data.cpio.gz
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

origin.patch
dontdiff-ignore-files-nclude-generated-kernelarchcross.patch
linux-next.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch

