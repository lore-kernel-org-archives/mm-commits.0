Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B2425761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742131; cv=none; b=cbKWEORlSOuCRB/+lhnt4zO2YebhVWcCZ5y4gf36Qo4njaiZ7YOMuHjMAVtLh3j3DQ9Kl6rOBLFiL9TH3sWn1XRqBlZHmEjhkFlxLrF1thFTb9tCdJ2Clp1NhHVe/BfIBzg4ZB/jwD/S6JnnKR1TSzQUJGwAJ06q4Pstu3F36sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742131; c=relaxed/simple;
	bh=A4sJYctGihbiy8mYdFfAdeEBTQ+KsuB8VxXUjn8QWc0=;
	h=Date:To:From:Subject:Message-Id; b=jHzPlN71PJ+sLRgvV8S1l3qFV4gx6rm8Nl9vi5QWSH0BQdEHxh7qgXYPDiXvlitT2SUoSkDe9pQH9JXmwnXui1uWeKRq0MkEBaOKncqSzBxejRHp3PJbZno2DR01wcaF0N3JffcndpDcUcrAPeF3CYXKDPG1A/Z0d/gOwc0RLqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UyG0Eky0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UyG0Eky0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6B0C4CEE2;
	Mon, 13 Jan 2025 04:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742131;
	bh=A4sJYctGihbiy8mYdFfAdeEBTQ+KsuB8VxXUjn8QWc0=;
	h=Date:To:From:Subject:From;
	b=UyG0Eky0pGz1Ow12AUZObyXXpgvXslJBS24Lm4LF3/MqovPAz65uXGpH8qnk5ibLR
	 KfKmzPJU9MF80OZk8zretH9IVxqitm82w+QHrtRkvlVPLg9UnXpV2GHAHdDj+RopLJ
	 cU/AoJ2jSDcf7ZV3ZItec+qg10B6Nv4XsomoLPic=
Date: Sun, 12 Jan 2025 20:22:10 -0800
To: mm-commits@vger.kernel.org,jserv@ccns.ncku.edu.tw,geert@linux-m68k.org,corbet@lwn.net,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] documentation-core-api-min_heap-add-author-information.patch removed from -mm tree
Message-Id: <20250113042211.0C6B0C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation/core-api: min_heap: add author information
has been removed from the -mm tree.  Its filename was
     documentation-core-api-min_heap-add-author-information.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: Documentation/core-api: min_heap: add author information
Date: Sat, 30 Nov 2024 02:12:22 +0800

As with other documentation files, author information is added to
min_heap.rst, providing contact details for any questions regarding the
Min Heap API or the document itself.

Link: https://lkml.kernel.org/r/20241129181222.646855-5-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/min_heap.rst |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/core-api/min_heap.rst~documentation-core-api-min_heap-add-author-information
+++ a/Documentation/core-api/min_heap.rst
@@ -4,6 +4,8 @@
 Min Heap API
 ============
 
+:Author: Kuan-Wei Chiu <visitorckw@gmail.com>
+
 Introduction
 ============
 
_

Patches currently in -mm which might be from visitorckw@gmail.com are


