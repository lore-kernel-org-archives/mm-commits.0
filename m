Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B765478D
	for <mm-commits@vger.kernel.org>; Sat,  5 Sep 2026 18:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788634097; cv=none; b=ju2+eWdbI105/txZneIfISkQIASMwyXxVgY9/t09fwDFrOGScUBnowEtJ6Sze4vl0I64j8gfJjEBtz1emuxAACSP17ouWV69aqVIqdTAXU/fcrdXNRXtqgQyVB7d07vaEsE1qGC+3qSzHrBYHMUfWXZcpHnIF1cIx+Kiy0bc9o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788634097; c=relaxed/simple;
	bh=CGff9PK/UHFBqDBDd011V449BTRZpOoNHk3xau7Aopg=;
	h=Date:To:From:Subject:Message-Id; b=E772XS+dGea8z39GvJ+cRW4M7e1AbmUVVif/1glP6/Gpw0JrJThfX3KtZ9EziISL2UCh1J3ZHL0kcYKqI/75Av8gDP0xFmCYGXwWH0mQnBrjR9ePBvkphxoFYDFNt6B3L7pzOiHxr6YO6akUZVDPhbfDATLPd3vFMesyaF6wgoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BWN5DJ2Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BWN5DJ2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F316D1F00A3A;
	Sat,  5 Sep 2026 18:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788634096;
	bh=xUj6qLjEPcJWDM5TME5h7GuLY5sastlrRmObOejDBeo=;
	h=Date:To:From:Subject;
	b=BWN5DJ2YBAxYTtUV0xKCRNmeL9ySNlnCY/4DVsfXJIuj+ijgwZRiznMldREWqAOCJ
	 Q4nofgmb+Fn7/wzih7FT5ecvHGGDsQ1tTrhI0v7tOPDQiTI6JGg15hCsMyns72oPVk
	 e4221wCdDRPqDCSBk1RFA7ptiNn3cqO/Sg/6Zyvs=
Date: Sat, 05 Sep 2026 11:48:15 -0700
To: mm-commits@vger.kernel.org,chris.obbard@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-entry-for-christopher-obbard.patch removed from -mm tree
Message-Id: <20260905184815.F316D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update entry for Christopher Obbard
has been removed from the -mm tree.  Its filename was
     mailmap-update-entry-for-christopher-obbard.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christopher Obbard <chris.obbard@oss.qualcomm.com>
Subject: mailmap: update entry for Christopher Obbard
Date: Sat, 29 Aug 2026 12:28:23 +0100

I have changed employer; update my mailmap entry to point at my new email
address.

Link: https://lore.kernel.org/20260829-update-mail-oss-qualcomm-v2-1-1670c515f225@oss.qualcomm.com
Signed-off-by: Christopher Obbard <chris.obbard@oss.qualcomm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~mailmap-update-entry-for-christopher-obbard
+++ a/.mailmap
@@ -211,7 +211,8 @@ Christophe Leroy <chleroy@kernel.org> <c
 Christophe Leroy <chleroy@kernel.org> <christophe.leroy@csgroup.eu>
 Christophe Leroy <chleroy@kernel.org> <christophe.leroy2@cs-soprasteria.com>
 Christophe Ricard <christophe.ricard@gmail.com>
-Christopher Obbard <christopher.obbard@linaro.org> <chris.obbard@collabora.com>
+Christopher Obbard <chris.obbard@oss.qualcomm.com> <chris.obbard@collabora.com>
+Christopher Obbard <chris.obbard@oss.qualcomm.com> <christopher.obbard@linaro.org>
 Christoph Hellwig <hch@lst.de>
 Christoph Manszewski <c.manszewski@gmail.com> <christoph.manszewski@intel.com>
 Christoph Paasch <cpaasch@openai.com> <christoph.paasch@gmail.com>
_

Patches currently in -mm which might be from chris.obbard@oss.qualcomm.com are


