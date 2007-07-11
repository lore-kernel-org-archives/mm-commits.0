From: akpm@linux-foundation.org
Subject: + m32r-a-maintainers-entry-for-the-m32r-architecture.patch added to -mm tree
Date: Wed, 11 Jul 2007 12:13:42 -0700
Message-ID: <200707111913.l6BJDgZU010148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47019 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755422AbXGKTN6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jul 2007 15:13:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: takata@linux-m32r.org


The patch titled
     m32r: A MAINTAINERS entry for the M32R architecture
has been added to the -mm tree.  Its filename is
     m32r-a-maintainers-entry-for-the-m32r-architecture.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m32r: A MAINTAINERS entry for the M32R architecture
From: Hirokazu Takata <takata@linux-m32r.org>

Signed-off-by: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+)

diff -puN MAINTAINERS~m32r-a-maintainers-entry-for-the-m32r-architecture MAINTAINERS
--- a/MAINTAINERS~m32r-a-maintainers-entry-for-the-m32r-architecture
+++ a/MAINTAINERS
@@ -2351,6 +2351,14 @@ M:	matthew@wil.cx
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 
+M32R ARCHITECTURE
+P:	Hirokazu Takata
+M:	takata@linux-m32r.org
+L:	linux-m32r@ml.linux-m32r.org
+L:	linux-m32r-ja@ml.linux-m32r.org (in Japanese)
+W:	http://www.linux-m32r.org/
+S:	Maintained
+
 M68K ARCHITECTURE
 P:	Geert Uytterhoeven
 M:	geert@linux-m68k.org
_

Patches currently in -mm which might be from takata@linux-m32r.org are

lots-of-architectures-enable-arbitary-speed-tty-support.patch
m32r-enable-arbitary-speed-tty-rate-setting.patch
m32r-a-maintainers-entry-for-the-m32r-architecture.patch
