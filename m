From: akpm@linux-foundation.org
Subject: + gitignore-ignore-lz4-files.patch added to -mm tree
Date: Thu, 11 Jul 2013 14:24:44 -0700
Message-ID: <51df229c.ciWu7AjwdVuR2NfW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab3GKVYp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Jul 2013 17:24:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kyungsik.lee@lge.com, markus@trippelsdorf.de

Subject: + gitignore-ignore-lz4-files.patch added to -mm tree
To: markus@trippelsdorf.de,kyungsik.lee@lge.com
From: akpm@linux-foundation.org
Date: Thu, 11 Jul 2013 14:24:44 -0700


The patch titled
     Subject: .gitignore: ignore *.lz4 files
has been added to the -mm tree.  Its filename is
     gitignore-ignore-lz4-files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/gitignore-ignore-lz4-files.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/gitignore-ignore-lz4-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: .gitignore: ignore *.lz4 files

Now that lz4 kernel compression is available, add *.lz4 to .gitignore.

Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Acked-by: Kyungsik Lee <kyungsik.lee@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .gitignore |    1 +
 1 file changed, 1 insertion(+)

diff -puN .gitignore~gitignore-ignore-lz4-files .gitignore
--- a/.gitignore~gitignore-ignore-lz4-files
+++ a/.gitignore
@@ -29,6 +29,7 @@ modules.builtin
 *.bz2
 *.lzma
 *.xz
+*.lz4
 *.lzo
 *.patch
 *.gcno
_

Patches currently in -mm which might be from markus@trippelsdorf.de are

gitignore-ignore-lz4-files.patch

