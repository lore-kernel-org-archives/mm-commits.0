From: akpm@linux-foundation.org
Subject: [merged] mailmap-fix-krzysztof-kozlowskis-misspelled-name.patch
 removed from -mm tree
Date: Fri, 29 Apr 2016 15:05:20 -0700
Message-ID: <5723daa0.PYMuHZbtr9aI8ivP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbcD2WFV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2016 18:05:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzk@kernel.org, herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: fix Krzysztof Kozlowski's misspelled name
has been removed from the -mm tree.  Its filename was
     mailmap-fix-krzysztof-kozlowskis-misspelled-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: mailmap: fix Krzysztof Kozlowski's misspelled name

Patchwork introduced garbled polish character in commit 1e3012d0fdc5
("crypto: s5p-sss - Use memcpy_toio for iomem annotated memory") so fix
the mail mapping.  Additionally prefer to use kernel.org account for
personal work, instead of my gmail address.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

diff -puN .mailmap~mailmap-fix-krzysztof-kozlowskis-misspelled-name .mailmap
--- a/.mailmap~mailmap-fix-krzysztof-kozlowskis-misspelled-name
+++ a/.mailmap
@@ -79,6 +79,7 @@ Kay Sievers <kay.sievers@vrfy.org>
 Kenneth W Chen <kenneth.w.chen@intel.com>
 Konstantin Khlebnikov <koct9i@gmail.com> <k.khlebnikov@samsung.com>
 Koushik <raghavendra.koushik@neterion.com>
+Krzysztof Kozlowski <krzk@kernel.org> <k.kozlowski.k@gmail.com>
 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
 Leonid I Ananiev <leonid.i.ananiev@intel.com>
 Linas Vepstas <linas@austin.ibm.com>
_

Patches currently in -mm which might be from krzk@kernel.org are


