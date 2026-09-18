Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A163B45D923
	for <mm-commits@vger.kernel.org>; Fri, 18 Sep 2026 05:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789710230; cv=none; b=cp39TDyedIQ/sXRaClh4NxLegSBc8zQ+sJctuilgdmrKzv9e1odmo2NBGB4kE3dSzBjzpXITtMNMEibFBJe3czGGP35eMEzzkMyWwQ0Mg9k5+q5z59CqzUS1iwVKN+9O8fq5MYMgZ1OfkXL+NA9U6kA7IS7f2Ka4pv0Unlz1apU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789710230; c=relaxed/simple;
	bh=a8LLESruURF79ZvaGuxkSg0VGr96L4SUzmDud+M5Jtg=;
	h=Date:To:From:Subject:Message-Id; b=lSOsldIqHV12s2QpDkKmG/6PaZODoSoWA8n8DApo7m/XUPGvSp7secBKb4AxDzJVK8nsoB5vw9dPaw9v8fh2QC0qVMj5zwuLSrzIRMinkzF4hnzANekQFxnV9WUBmGujypkv+guV+bUpoQ7S6h9+QOsmCG09zCdkXih6DkJCROs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0SG9oXCK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0SG9oXCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CC11F00893;
	Fri, 18 Sep 2026 05:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789710228;
	bh=77tu94ZCpyWLmXGliRmM35TWV8xPw8skEBFcU+0tvTM=;
	h=Date:To:From:Subject;
	b=0SG9oXCKcEx4YsZipflGT+O2ovUF5cN/L5cC3okQPvbVaQn/6jEeU8XBZ9sqXI72M
	 b20sZ4sOVxhM88TuCB3QDCmVNn08iwG0rVsilOybia25eEbuEcpABQwRldr4kR520R
	 X40UAfN7e+LRM/UbBrhgoJeqG/HKOnnXbxnP3Kgk=
Date: Thu, 17 Sep 2026 22:43:48 -0700
To: mm-commits@vger.kernel.org,calvin.bai@ugreen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-haowen-bais-email-address.patch removed from -mm tree
Message-Id: <20260918054348.74CC11F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update Haowen Bai's email address
has been removed from the -mm tree.  Its filename was
     mailmap-update-haowen-bais-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Haowen Bai <calvin.bai@ugreen.com>
Subject: mailmap: update Haowen Bai's email address
Date: Thu, 3 Sep 2026 21:28:54 +0800

Map Haowen Bai's former Meizu and current Ugreen addresses to
baihaowen88@gmail.com as the canonical public address.

Link: https://lore.kernel.org/20260903132854.1930923-1-calvin.bai@ugreen.com
Signed-off-by: Haowen Bai <calvin.bai@ugreen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-update-haowen-bais-email-address
+++ a/.mailmap
@@ -355,6 +355,8 @@ Hans Verkuil <hverkuil@kernel.org> <hver
 Hans Verkuil <hverkuil@kernel.org> <hansverk@cisco.com>
 Hans Verkuil <hverkuil@kernel.org> <hans.verkuil@cisco.com>
 Hao Ge <hao.ge@linux.dev> <gehao@kylinos.cn>
+Haowen Bai <baihaowen88@gmail.com> <baihaowen@meizu.com>
+Haowen Bai <baihaowen88@gmail.com> <calvin.bai@ugreen.com>
 Harry Yoo <harry.yoo@oracle.com> <42.hyeyoo@gmail.com>
 Harry Yoo <harry@kernel.org> <harry.yoo@oracle.com>
 Heiko Carstens <hca@linux.ibm.com> <h.carstens@de.ibm.com>
_

Patches currently in -mm which might be from calvin.bai@ugreen.com are


