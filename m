From: akpm@linux-foundation.org
Subject: + mailmap-update-javier-martinez-canillas-email.patch added to
 -mm tree
Date: Thu, 15 Oct 2015 12:44:33 -0700
Message-ID: <56200221.3rBniwP7FG1mU0dg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbbJOToe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Oct 2015 15:44:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: javier@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update Javier Martinez Canillas' email
has been added to the -mm tree.  Its filename is
     mailmap-update-javier-martinez-canillas-email.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mailmap-update-javier-martinez-canillas-email.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mailmap-update-javier-martinez-canillas-email.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Javier Martinez Canillas <javier@osg.samsung.com>
Subject: mailmap: update Javier Martinez Canillas' email

The get_maintainer script still reports my old Collabora email based on
old commits but that address no longer exist so update mailmap to report
my current email and avoid people sending to the old address.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

diff -puN .mailmap~mailmap-update-javier-martinez-canillas-email .mailmap
--- a/.mailmap~mailmap-update-javier-martinez-canillas-email
+++ a/.mailmap
@@ -59,6 +59,7 @@ James Bottomley <jejb@mulgrave.(none)>
 James Bottomley <jejb@titanic.il.steeleye.com>
 James E Wilson <wilson@specifix.com>
 James Ketrenos <jketreno@io.(none)>
+<javier@osg.samsung.com> <javier.martinez@collabora.co.uk>
 Jean Tourrilhes <jt@hpl.hp.com>
 Jeff Garzik <jgarzik@pretzel.yyz.us>
 Jens Axboe <axboe@suse.de>
_

Patches currently in -mm which might be from javier@osg.samsung.com are

mailmap-update-javier-martinez-canillas-email.patch

