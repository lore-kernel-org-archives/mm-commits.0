From: akpm@linux-foundation.org
Subject: [merged] gitignore-ignore-lz4-files.patch removed from -mm tree
Date: Tue, 06 Aug 2013 12:37:29 -0700
Message-ID: <52015079.DP5Y1/EmQtn53wPV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55638 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509Ab3HFTha (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Aug 2013 15:37:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kyungsik.lee@lge.com, markus@trippelsdorf.de

Subject: [merged] gitignore-ignore-lz4-files.patch removed from -mm tree
To: markus@trippelsdorf.de,kyungsik.lee@lge.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 06 Aug 2013 12:37:29 -0700


The patch titled
     Subject: .gitignore: ignore *.lz4 files
has been removed from the -mm tree.  Its filename was
     gitignore-ignore-lz4-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

