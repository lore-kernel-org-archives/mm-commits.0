From: akpm@linux-foundation.org
Subject: [merged] documentation-changes-perl-is-needed-to-build-the-kernel.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:45:10 -0700
Message-ID: <200906182245.n5IMjAZ8004276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757314AbZFRWpn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:45:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jluis@escomposlinux.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Documentation/Changes: perl is needed to build the kernel
has been removed from the -mm tree.  Its filename was
     documentation-changes-perl-is-needed-to-build-the-kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/Changes: perl is needed to build the kernel
From: Jose Luis Perez Diez <jluis@escomposlinux.org>

Perl is used on the kernel Makefile to generate documentation, firmwares
in c source form, sources, graphs, and some headers and this fact is
undocumented.

[akpm@linux-foundation.org: 80-columns, please]
Signed-off-by: Jose Luis Perez Diez <jluis@escomposlinux.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/Changes |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN Documentation/Changes~documentation-changes-perl-is-needed-to-build-the-kernel Documentation/Changes
--- a/Documentation/Changes~documentation-changes-perl-is-needed-to-build-the-kernel
+++ a/Documentation/Changes
@@ -72,6 +72,13 @@ assembling the 16-bit boot code, removin
 your kernel.  This change does, however, mean that you need a recent
 release of binutils.
 
+Perl
+----
+
+You will need perl 5 and the following modules: Getopt::Long, Getopt::Std,
+File::Basename, and File::Find to build the kernel.
+
+
 System utilities
 ================
 
_

Patches currently in -mm which might be from jluis@escomposlinux.org are

origin.patch

