From: akpm@linux-foundation.org
Subject: [merged] scripts-spellingtxt-add-some-typo-words.patch removed
 from -mm tree
Date: Tue, 28 Feb 2017 12:52:01 -0800
Message-ID: <58b5e2f1.5xhAsTf9aOko/WT3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52820 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751936AbdB1UwC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:52:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jinb.park7@gmail.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add some typo-words
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-some-typo-words.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jinbum Park <jinb.park7@gmail.com>
Subject: scripts/spelling.txt: add some typo-words

I wrote a simple script to find new typo not in spelling.txt.
(https://github.com/jinb-park/find-linux-kernel-typo)

and get following result:

	[ rank ]
	63 paramaters
	18 alignement
	9 strucuture
	....

The number means how many files include the typo.
This patch adds these common typo.

Link: http://lkml.kernel.org/r/20170112113452.GA7042@pjb1027-Latitude-E5410
Signed-off-by: Jinbum Park <jinb.park7@gmail.com>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    3 +++
 1 file changed, 3 insertions(+)

diff -puN scripts/spelling.txt~scripts-spellingtxt-add-some-typo-words scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-some-typo-words
+++ a/scripts/spelling.txt
@@ -74,6 +74,7 @@ algoritms||algorithms
 algorrithm||algorithm
 algorritm||algorithm
 aligment||alignment
+alignement||alignment
 allign||align
 allocatrd||allocated
 allocte||allocate
@@ -746,6 +747,7 @@ pakage||package
 pallette||palette
 paln||plan
 paramameters||parameters
+paramaters||parameters
 paramater||parameter
 parametes||parameters
 parametised||parametrised
@@ -990,6 +992,7 @@ straming||streaming
 struc||struct
 structres||structures
 stuct||struct
+strucuture||structure
 stucture||structure
 sturcture||structure
 subdirectoires||subdirectories
_

Patches currently in -mm which might be from jinb.park7@gmail.com are


