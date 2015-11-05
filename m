From: akpm@linux-foundation.org
Subject: + get_maintainer-its-pattern-depth-not-pattern-depth.patch added
 to -mm tree
Date: Wed, 04 Nov 2015 17:32:02 -0800
Message-ID: <563ab192.2xjcq42OStzGCn2R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47807 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031510AbbKEBcD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Nov 2015 20:32:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: computersforpeace@gmail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: it's '--pattern-depth', not '-pattern-depth'
has been added to the -mm tree.  Its filename is
     get_maintainer-its-pattern-depth-not-pattern-depth.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/get_maintainer-its-pattern-depth-not-pattern-depth.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/get_maintainer-its-pattern-depth-not-pattern-depth.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Brian Norris <computersforpeace@gmail.com>
Subject: get_maintainer: it's '--pattern-depth', not '-pattern-depth'

Though it appears that Perl's GetOptions will take either, the latter is
not documented in the options listing.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/get_maintainer.pl~get_maintainer-its-pattern-depth-not-pattern-depth scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainer-its-pattern-depth-not-pattern-depth
+++ a/scripts/get_maintainer.pl
@@ -813,7 +813,7 @@ Other options:
   --help => show this help information
 
 Default options:
-  [--email --nogit --git-fallback --m --n --l --multiline -pattern-depth=0
+  [--email --nogit --git-fallback --m --n --l --multiline --pattern-depth=0
    --remove-duplicates --rolestats]
 
 Notes:
_

Patches currently in -mm which might be from computersforpeace@gmail.com are

get_maintainer-add-missing-documentation-for-git-blame-signatures.patch
get_maintainer-its-pattern-depth-not-pattern-depth.patch
get_maintainer-add-no-foo-options-to-help.patch
get_maintainer-r-list-reviewer-is-on-by-default.patch

