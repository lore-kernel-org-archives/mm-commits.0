From: akpm@linux-foundation.org
Subject: + credits-update-expired-fingerprint-and-fix-details.patch added to -mm tree
Date: Tue, 22 Nov 2011 14:55:55 -0800
Message-ID: <201111222255.pAMMttYe020019@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:51295 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab1KVWz6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 17:55:58 -0500
Received: by fabs1 with SMTP id s1so32484fab.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2011 14:55:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kees@outflux.net


The patch titled
     Subject: CREDITS: update Kees's expired fingerprint and fix details
has been added to the -mm tree.  Its filename is
     credits-update-expired-fingerprint-and-fix-details.patch

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
From: Kees Cook <kees@outflux.net>
Subject: CREDITS: update Kees's expired fingerprint and fix details

Small clean-up for my CREDITS entry; the GPG fingerprint was not up to
date, so I fixed other details at the same time too.

Signed-off-by: Kees Cook <kees@outflux.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN CREDITS~credits-update-expired-fingerprint-and-fix-details CREDITS
--- a/CREDITS~credits-update-expired-fingerprint-and-fix-details
+++ a/CREDITS
@@ -693,10 +693,13 @@ S: Oxfordshire, UK.
 
 N: Kees Cook
 E: kees@outflux.net
-W: http://outflux.net/
-P: 1024D/17063E6D 9FA3 C49C 23C9 D1BC 2E30  1975 1FFF 4BA9 1706 3E6D
-D: Minor updates to SCSI types, added /proc/pid/maps protection
+E: kees@ubuntu.com
+E: keescook@chromium.org
+W: http://outflux.net/blog/
+P: 4096R/DC6DC026 A5C3 F68F 229D D60F 723E  6E13 8972 F4DF DC6D C026
+D: Various security things, bug fixes, and documentation.
 S: (ask for current address)
+S: Portland, Oregon
 S: USA
 
 N: Robin Cornelius
_
Subject: Subject: CREDITS: update Kees's expired fingerprint and fix details

Patches currently in -mm which might be from kees@outflux.net are

linux-next.patch
credits-update-expired-fingerprint-and-fix-details.patch
ramoops-update-parameters-only-after-successful-init.patch

