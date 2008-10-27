From: akpm@linux-foundation.org
Subject: + cpu-freq-documentation-add-blackfin-to-list-of-supported-processors.patch added to -mm tree
Date: Sun, 26 Oct 2008 20:41:11 -0700
Message-ID: <200810270341.m9R3fBa2030854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48928 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750740AbYJ0DmF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 26 Oct 2008 23:42:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rgetz@blackfin.uclinux.org, cooloney@kernel.org


The patch titled
     cpu-freq/Documentation: add Blackfin to list of supported processors
has been added to the -mm tree.  Its filename is
     cpu-freq-documentation-add-blackfin-to-list-of-supported-processors.patch

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
Subject: cpu-freq/Documentation: add Blackfin to list of supported processors
From: Robin Getz <rgetz@blackfin.uclinux.org>

Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpu-freq/user-guide.txt |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN Documentation/cpu-freq/user-guide.txt~cpu-freq-documentation-add-blackfin-to-list-of-supported-processors Documentation/cpu-freq/user-guide.txt
--- a/Documentation/cpu-freq/user-guide.txt~cpu-freq-documentation-add-blackfin-to-list-of-supported-processors
+++ a/Documentation/cpu-freq/user-guide.txt
@@ -23,6 +23,7 @@ Contents:
 1.3 sparc64
 1.4 ppc
 1.5 SuperH
+1.6 Blackfin
 
 2. "Policy" / "Governor"?
 2.1 Policy
@@ -97,6 +98,17 @@ The following SuperH processors are supp
 SH-3
 SH-4
 
+1.6 Blackfin
+------------
+
+The following Blackfin processors are supported by cpufreq:
+
+BF522, BF523, BF524, BF525, BF526, BF527, Rev 0.1 or higher
+BF531, BF532, BF533, Rev 0.3 or higher
+BF534, BF536, BF537, Rev 0.2 or higher
+BF561, Rev 0.3 or higher
+BF542, BF544, BF547, BF548, BF549, Rev 0.1 or higher
+
 
 2. "Policy" / "Governor" ?
 ==========================
_

Patches currently in -mm which might be from rgetz@blackfin.uclinux.org are

cpu-freq-documentation-add-blackfin-to-list-of-supported-processors.patch

