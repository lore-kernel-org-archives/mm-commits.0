From: akpm@linux-foundation.org
Subject: + maintainers-add-k-pattern-for-trivial-patches.patch added to -mm tree
Date: Wed, 30 Mar 2011 13:54:42 -0700
Message-ID: <201103302054.p2UKsgYU008621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932252Ab1C3UzV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Mar 2011 16:55:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, agimenez@sysvalve.es, trivial@kernel.org


The patch titled
     MAINTAINERS: Add "K:" pattern for TRIVIAL PATCHES
has been added to the -mm tree.  Its filename is
     maintainers-add-k-pattern-for-trivial-patches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: MAINTAINERS: Add "K:" pattern for TRIVIAL PATCHES
=46rom: Joe Perches <joe@perches.com>

Since scripts/get_maintainer.pl was updated to search content before th=
e
patch by commit 7764dcb ("get_maintainer.pl: allow "K:" pattern tests t=
o
match non-patch text") perhaps this might direct a few more patches the
right place.

Original-patch-by: L. Alberto Gim=E9nez <agimenez@sysvalve.es>
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-k-pattern-for-trivial-patches MAI=
NTAINERS
--- a/MAINTAINERS~maintainers-add-k-pattern-for-trivial-patches
+++ a/MAINTAINERS
@@ -6208,6 +6208,7 @@ TRIVIAL PATCHES
 M:	Jiri Kosina <trivial@kernel.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git
 S:	Maintained
+K:	^Subject:.*(?i)trivial
=20
 TTY LAYER
 M:	Greg Kroah-Hartman <gregkh@suse.de>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
maintainers-add-k-pattern-for-trivial-patches.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
