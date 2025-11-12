Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F2E14B96E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908612; cv=none; b=Is9e1G26aj0fZtkJ2anTWT8N2miJBLY3BbfV09Co+cvgxLb2FdCbHwh2ZO79fFoFAhUFUbtxwFWNi61lavjHetuiuIBtfifUqXnl9kbRd4w4F2GnB4XopURe+lmFCys5WK+Arqi6Zf/JnAS1oFV09igdUag/7qH4L5VH7QqaK/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908612; c=relaxed/simple;
	bh=Mut/ecihJY2miw+i2WmSxADyjVTArC1rC3b/nNnbZoE=;
	h=Date:To:From:Subject:Message-Id; b=sKPpv3RDozdw5EhQ5npE9Fms9vBxZqgod4xSfjrEiwQVYEe1MgI0pevFj2wxHGOq6FjvW4NU4SqqN1vhvCg6QChqItBm11WWb2YG6shh0Fm9+aJJE6V1XU8x31DeKpQpdeRdQG4IP0y9gOVL5lnsAol7xxVohNJyJw59ZvRW2K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v/u6weR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v/u6weR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA8FC4CEF5;
	Wed, 12 Nov 2025 00:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908612;
	bh=Mut/ecihJY2miw+i2WmSxADyjVTArC1rC3b/nNnbZoE=;
	h=Date:To:From:Subject:From;
	b=v/u6weR9IXTVuf4ZF6VyXr4dZX/3UQvFaZ0taYTCZS4FZOlzRaxAe+1Woyz2AZDqO
	 PgCt/Ot34mA6STLRvjWyBBiELe44S9P1YO3Fyuo+UtVABr49pKYmO5D6xeFZtKbalM
	 bB1mrxoEmbKnZpf9XUrz0cb9Yvhy+rXsLcagdJGw=
Date: Tue, 11 Nov 2025 16:50:11 -0800
To: mm-commits@vger.kernel.org,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-add-entry-for-hao-ge.patch removed from -mm tree
Message-Id: <20251112005012.4FA8FC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: add entry for Hao Ge
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-hao-ge.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Ge <gehao@kylinos.cn>
Subject: mailmap: add entry for Hao Ge
Date: Thu, 30 Oct 2025 20:17:46 +0800

Use hao.ge@linux.dev as the main address for kernel work

Link: https://lkml.kernel.org/r/20251030121746.230747-1-hao.ge@linux.dev
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-hao-ge
+++ a/.mailmap
@@ -298,6 +298,7 @@ Hans de Goede <hansg@kernel.org> <hdegoe
 Hans Verkuil <hverkuil@kernel.org> <hverkuil@xs4all.nl>
 Hans Verkuil <hverkuil@kernel.org> <hverkuil-cisco@xs4all.nl>
 Hans Verkuil <hverkuil@kernel.org> <hansverk@cisco.com>
+Hao Ge <hao.ge@linux.dev> <gehao@kylinos.cn>
 Harry Yoo <harry.yoo@oracle.com> <42.hyeyoo@gmail.com>
 Heiko Carstens <hca@linux.ibm.com> <h.carstens@de.ibm.com>
 Heiko Carstens <hca@linux.ibm.com> <heiko.carstens@de.ibm.com>
_

Patches currently in -mm which might be from gehao@kylinos.cn are


