From: akpm@linux-foundation.org
Subject: - cpu-freq-documentation-add-blackfin-to-list-of-supported-processors.patch removed from -mm tree
Date: Wed, 26 Nov 2008 12:45:55 -0800
Message-ID: <200811262045.mAQKjtRS010490@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752723AbYKZUrD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 15:47:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rgetz@blackfin.uclinux.org, cooloney@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cpu-freq/Documentation: add Blackfin to list of supported processors
has been removed from the -mm tree.  Its filename was
     cpu-freq-documentation-add-blackfin-to-list-of-supported-processors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

