From: akpm@linux-foundation.org
Subject: [merged] credits-update-expired-fingerprint-and-fix-details.patch removed from -mm tree
Date: Fri, 09 Dec 2011 12:07:56 -0800
Message-ID: <201112092007.pB9K7uCm020413@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:62638 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab1LIUH6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 15:07:58 -0500
Received: by qcsg15 with SMTP id g15so395338qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 09 Dec 2011 12:07:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kees@outflux.net, mm-commits@vger.kernel.org


The patch titled
     Subject: CREDITS: update Kees's expired fingerprint and fix details
has been removed from the -mm tree.  Its filename was
     credits-update-expired-fingerprint-and-fix-details.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -688,10 +688,13 @@ S: Oxfordshire, UK.
 
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

Patches currently in -mm which might be from kees@outflux.net are

origin.patch
linux-next.patch
ramoops-update-parameters-only-after-successful-init.patch

