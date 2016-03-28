From: akpm@linux-foundation.org
Subject: + maintainers-orangefs-mailing-list-is-subscribers-only.patch
 added to -mm tree
Date: Mon, 28 Mar 2016 14:50:25 -0700
Message-ID: <56f9a721.jUE7p3wOYqroHmLf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbcC1Vu0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2016 17:50:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, hubcap@omnibond.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: orangefs mailing list is subscribers-only
has been added to the -mm tree.  Its filename is
     maintainers-orangefs-mailing-list-is-subscribers-only.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-orangefs-mailing-list-is-subscribers-only.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-orangefs-mailing-list-is-subscribers-only.patch

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
Subject: MAINTAINERS: orangefs mailing list is subscribers-only

So update MAINTAINERS to say so.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-orangefs-mailing-list-is-subscribers-only MAINTAINERS
--- a/MAINTAINERS~maintainers-orangefs-mailing-list-is-subscribers-only
+++ a/MAINTAINERS
@@ -8253,7 +8253,7 @@ F:	Documentation/filesystems/overlayfs.t
 
 ORANGEFS FILESYSTEM
 M:	Mike Marshall <hubcap@omnibond.com>
-L:	pvfs2-developers@beowulf-underground.org
+L:	pvfs2-developers@beowulf-underground.org (subscribers-only)
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/hubcap/linux.git
 S:	Supported
 F:	fs/orangefs/
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-orangefs-mailing-list-is-subscribers-only.patch
checkpatch-add-prefer_is_enabled-test.patch
checkpatch-improve-constant_comparison-test-for-structure-members.patch

