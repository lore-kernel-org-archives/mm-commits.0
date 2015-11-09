From: akpm@linux-foundation.org
Subject: [merged] get_maintainer-r-list-reviewer-is-on-by-default.patch
 removed from -mm tree
Date: Mon, 09 Nov 2015 11:46:10 -0800
Message-ID: <5640f802.K79eUWzoidw0gLbL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57336 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbbKITqK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:46:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: computersforpeace@gmail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: --r (list reviewer) is on by default
has been removed from the -mm tree.  Its filename was
     get_maintainer-r-list-reviewer-is-on-by-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Brian Norris <computersforpeace@gmail.com>
Subject: get_maintainer: --r (list reviewer) is on by default

We don't consistenly document the default value next to the option
listing, but we do have a list of defaults here, so let's keep it up to
date.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/get_maintainer.pl~get_maintainer-r-list-reviewer-is-on-by-default scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainer-r-list-reviewer-is-on-by-default
+++ a/scripts/get_maintainer.pl
@@ -813,7 +813,7 @@ Other options:
   --help => show this help information
 
 Default options:
-  [--email --nogit --git-fallback --m --n --l --multiline --pattern-depth=0
+  [--email --nogit --git-fallback --m --r --n --l --multiline --pattern-depth=0
    --remove-duplicates --rolestats]
 
 Notes:
_

Patches currently in -mm which might be from computersforpeace@gmail.com are


