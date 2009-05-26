From: akpm@linux-foundation.org
Subject: + documentation-changes-perl-is-needed-to-build-the-kernel.patch added to -mm tree
Date: Tue, 26 May 2009 16:07:51 -0700
Message-ID: <200905262307.n4QN7pnk025194@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757845AbZEZXIQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 19:08:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jluis@escomposlinux.org, sam@ravnborg.org


The patch titled
     Documentation/Changes: perl is needed to build the kernel
has been added to the -mm tree.  Its filename is
     documentation-changes-perl-is-needed-to-build-the-kernel.patch

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
Subject: Documentation/Changes: perl is needed to build the kernel
From: Jose Luis Perez Diez <jluis@escomposlinux.org>

Perl is used on the kernel Makefile to generate documentation, firmwares
in c source form, sources, graphs, and some headers and this fact is
undocumented.

Signed-off-by: Jose Luis Perez Diez <jluis@escomposlinux.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/Changes |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN Documentation/Changes~documentation-changes-perl-is-needed-to-build-the-kernel Documentation/Changes
--- a/Documentation/Changes~documentation-changes-perl-is-needed-to-build-the-kernel
+++ a/Documentation/Changes
@@ -71,6 +71,13 @@ assembling the 16-bit boot code, removin
 your kernel.  This change does, however, mean that you need a recent
 release of binutils.
 
+Perl
+----
+
+You will need perl 5 and the following modules: Getopt::Long, Getopt::Std, File::Basename, and File::Find to build the kernel.
+
+
+
 System utilities
 ================
 
_

Patches currently in -mm which might be from jluis@escomposlinux.org are

documentation-changes-perl-is-needed-to-build-the-kernel.patch
documentation-changes-perl-is-needed-to-build-the-kernel-fix.patch

