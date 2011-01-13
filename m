From: akpm@linux-foundation.org
Subject: [merged] decompressors-remove-unused-constant-from-inflateh.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:10:45 -0800
Message-ID: <201101132013.p0DKDQxr030456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757399Ab1AMUN7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:13:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasse.collin@tukaani.org, mm-commits@vger.kernel.org


The patch titled
     decompressors: remove unused constant from inflate.h
has been removed from the -mm tree.  Its filename was
     decompressors-remove-unused-constant-from-inflateh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: decompressors: remove unused constant from inflate.h
From: Lasse Collin <lasse.collin@tukaani.org>

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/decompress/inflate.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/linux/decompress/inflate.h~decompressors-remove-unused-constant-from-inflateh include/linux/decompress/inflate.h
--- a/include/linux/decompress/inflate.h~decompressors-remove-unused-constant-from-inflateh
+++ a/include/linux/decompress/inflate.h
@@ -1,9 +1,6 @@
 #ifndef INFLATE_H
 #define INFLATE_H
 
-/* Other housekeeping constants */
-#define INBUFSIZ 4096
