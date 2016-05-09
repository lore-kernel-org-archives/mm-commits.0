From: akpm@linux-foundation.org
Subject: + maintainers-remove-koichi-yasutake.patch added to -mm tree
Date: Mon, 09 May 2016 13:55:15 -0700
Message-ID: <5730f933.CXL0loIrRmceDhbi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbcEIUzQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2016 16:55:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove Koichi Yasutake
has been added to the -mm tree.  Its filename is
     maintainers-remove-koichi-yasutake.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-remove-koichi-yasutake.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-remove-koichi-yasutake.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiri Slaby <jslaby@suse.cz>
Subject: MAINTAINERS: remove Koichi Yasutake

The MTA says:
 <yasutake.koichi@jp.panasonic.com>: unknown user:
    "yasutake.koichi@jp.panasonic.com"

Link: http://lkml.kernel.org/r/1462776755-9607-1-git-send-email-jslaby@suse.cz
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-koichi-yasutake MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-koichi-yasutake
+++ a/MAINTAINERS
@@ -8294,7 +8294,6 @@ F:	drivers/platform/x86/panasonic-laptop
 
 PANASONIC MN10300/AM33/AM34 PORT
 M:	David Howells <dhowells@redhat.com>
-M:	Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
 L:	linux-am33-list@redhat.com (moderated for non-subscribers)
 W:	ftp://ftp.redhat.com/pub/redhat/gnupro/AM33/
 S:	Maintained
_

Patches currently in -mm which might be from jslaby@suse.cz are

mn10300-let-exit_fpu-accept-a-task.patch
exit_thread-remove-empty-bodies.patch
exit_thread-accept-a-task-parameter-to-be-exited.patch
fork-free-thread-in-copy_process-on-failure.patch
maintainers-remove-linux-listsopenriscnet.patch
maintainers-remove-koichi-yasutake.patch
kgdb-depends-on-vt.patch

