From: akpm@linux-foundation.org
Subject: + maintainers-fix-link-to-gustavo-padovans-tree.patch added to -mm tree
Date: Tue, 06 Mar 2012 14:13:11 -0800
Message-ID: <20120306221311.46CB5A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:49526 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031133Ab2CFWNM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 17:13:12 -0500
Received: by qcsp5 with SMTP id p5so705208qcs.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 14:13:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johan.hedberg@intel.com, marcel@holtmann.org, padovan@profusion.mobi


The patch titled
     Subject: MAINTAINERS: Fix link to Gustavo Padovans tree
has been added to the -mm tree.  Its filename is
     maintainers-fix-link-to-gustavo-padovans-tree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johan Hedberg <johan.hedberg@intel.com>
Subject: MAINTAINERS: Fix link to Gustavo Padovans tree

Gustavo's tree is called just bluetooth.git and not bluetooth-2.6.git
anymore.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-fix-link-to-gustavo-padovans-tree MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-link-to-gustavo-padovans-tree
+++ a/MAINTAINERS
@@ -1517,7 +1517,7 @@ M:	"Gustavo F. Padovan" <padovan@profusi
 M:	Johan Hedberg <johan.hedberg@gmail.com>
 L:	linux-bluetooth@vger.kernel.org
 W:	http://www.bluez.org/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jh/bluetooth.git
 S:	Maintained
 F:	drivers/bluetooth/
@@ -1528,7 +1528,7 @@ M:	"Gustavo F. Padovan" <padovan@profusi
 M:	Johan Hedberg <johan.hedberg@gmail.com>
 L:	linux-bluetooth@vger.kernel.org
 W:	http://www.bluez.org/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jh/bluetooth.git
 S:	Maintained
 F:	net/bluetooth/
_
Subject: Subject: MAINTAINERS: Fix link to Gustavo Padovans tree

Patches currently in -mm which might be from johan.hedberg@intel.com are

linux-next.patch
maintainers-add-johan-to-bluetooth-maintainers.patch
maintainers-fix-link-to-gustavo-padovans-tree.patch

