From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-k-pattern-for-trivial-patches.patch removed from -mm tree
Date: Fri, 08 Apr 2011 11:05:19 -0700
Message-ID: <201104081803.p38I31uJ021313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756308Ab1DHSDM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Apr 2011 14:03:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, agimenez@sysvalve.es, trivial@kernel.org, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: Add "K:" pattern for TRIVIAL PATCHES
has been removed from the -mm tree.  Its filename was
     maintainers-add-k-pattern-for-trivial-patches.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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

linux-next.patch
maintainers-update-m68knommu-patterns.patch
maintainers-update-various-tty-patterns.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
