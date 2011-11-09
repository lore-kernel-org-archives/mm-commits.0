From: akpm@linux-foundation.org
Subject: + maintainers-staging-cx25821-add-l-linux-media.patch added to -mm tree
Date: Wed, 09 Nov 2011 14:19:27 -0800
Message-ID: <201111092219.pA9MJRON014202@hpaq2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:38269 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab1KIWTh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2011 17:19:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, gregkh@suse.de, mchehab@redhat.com


The patch titled
     Subject: MAINTAINERS: Staging: cx25821: Add L: linux-media
has been added to the -mm tree.  Its filename is
     maintainers-staging-cx25821-add-l-linux-media.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: Staging: cx25821: Add L: linux-media

Send patches to a mailing list.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN MAINTAINERS~maintainers-staging-cx25821-add-l-linux-media MAINTAINERS
--- a/MAINTAINERS~maintainers-staging-cx25821-add-l-linux-media
+++ a/MAINTAINERS
@@ -6286,6 +6286,11 @@ M:	Mori Hess <fmhess@users.sourceforge.n
 S:	Odd Fixes
 F:	drivers/staging/comedi/
 
+STAGING - CONEXANT CX25821 PCIE BRIDGE
+L:	linux-media@vger.kernel.org
+S:	Odd Fixes
+F:	drivers/staging/cx25821/
+
 STAGING - CRYSTAL HD VIDEO DECODER
 M:	Naren Sankar <nsankar@broadcom.com>
 M:	Jarod Wilson <jarod@wilsonet.com>
_
Subject: Subject: MAINTAINERS: Staging: cx25821: Add L: linux-media

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-staging-cx25821-add-l-linux-media.patch
checkpatch-update-signature-might-be-better-as-warning.patch

