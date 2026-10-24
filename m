Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792828036;
	b=kWe63M6AZ8ftOhrpkH69ewsnTgbQk3DqpoE/2/SIlUw5Rfj4LhJeChg7Q+790rdzRp6R
	 DZQ8esfQm6QSN8zoBArLwZY4T9hwcLpS+9tend8GRvLr7TayCQYSmpbPl9BKvDVKTvDto
	 cGKBaMA2wW8Ish2eT4GYCrkgsCL1DmuTubJjJoLkAX1JtKlN2OeGMfxz3JBLlHJKfrK25
	 z/Goc2EFrIe9euuRUnSjWMgFbb4rOZCda4aRDPMIdZeMyklYkzfrbJxbMNKE0Rb59E4G2
	 A29Ul3sXR8ZwNS9YL70MFznEo9oTBpXHUyonFBtM7l+JddSXoqVSwF1HnPoMRVElx3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792828036;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Wx4647d42IxCaot/LyL08DhLbLmNWyNEkyvk2hDA4Cc=;
	b=OXjytiEbNd2w1zCbsb9VanvGb+u4W5HElCTYGnRJALNHw9nt5GpBVpIndXajHcyrRVSr
	 cITT/zWy14fLRt6jO5CIZ/3VYjC6HTG1XiVHoiyhA5pwMz7OO60L1tb1qWrrjnTHrmWUH
	 tR46MhAKcstFYKD7LjqGBSgnDH2noW9SOt7uawSSlQd1zjZdMDYVedrsuVlwiRlA1kc4o
	 qL8j4Ge5u9LN5cDLFsZs8+0TsFNLrMlGg8XUmXcK4HP5NNqej2oSLs8FpbkQ6izxO1MjW
	 F3Mmaj18cOIRF+0bbh4XjxpSD/n01bal0KRTbi6ykYjTUxndY137UkW+gmfUL02FJ1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GjlAc9nO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B53E606A31B
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 07:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GjlAc9nO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0703B1F01829;
	Sat, 24 Oct 2026 07:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792828036;
	bh=Wx4647d42IxCaot/LyL08DhLbLmNWyNEkyvk2hDA4Cc=;
	h=Date:To:From:Subject;
	b=GjlAc9nOm6j9JGUqNiK73E1EeClGf99smZsIabrjocNHfMTjTuC6Mo4fAZaB6+kK8
	 /jLR98cifrCenOSlZ7QHl2u/TNnNayNbC7IEA0eIJZp2a2xn6GjvO/d9Mo1ufLU0iW
	 1n+xK+bRcCv+YZxfJfpI9WkCMjItO2K8l8aWcsoI=
Date: Sat, 24 Oct 2026 00:47:15 -0700
To: mm-commits@vger.kernel.org,andrew.jones@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-add-entries-for-andrew-jones.patch removed from -mm tree
Message-Id: <20261024074716.0703B1F01829@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mailmap: add entries for Andrew Jones
has been removed from the -mm tree.  Its filename was
     mailmap-add-entries-for-andrew-jones.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Jones <andrew.jones@linux.dev>
Subject: mailmap: add entries for Andrew Jones
Date: Thu, 22 Oct 2026 17:45:32 +0200

Use my linux.dev address for kernel correspondence, including for
contributions made with my other email addresses.

Link: https://lore.kernel.org/20261022154532.1374661-1-andrew.jones@linux.dev
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    4 ++++
 1 file changed, 4 insertions(+)

--- a/.mailmap~mailmap-add-entries-for-andrew-jones
+++ a/.mailmap
@@ -88,6 +88,10 @@ Andrej Shadura <andrew@shadura.me> <andr
 Andrew Donnellan <andrew+kernel@donnellan.id.au> <andrew@donnellan.id.au>
 Andrew Donnellan <andrew+kernel@donnellan.id.au> <ajd@linux.ibm.com>
 Andrew Donnellan <andrew+kernel@donnellan.id.au> <andrew.donnellan@au1.ibm.com>
+Andrew Jones <andrew.jones@linux.dev> <ajones@ventanamicro.com>
+Andrew Jones <andrew.jones@linux.dev> <andrew.jones@oss.qualcomm.com>
+Andrew Jones <andrew.jones@linux.dev> <anjones@nvidia.com>
+Andrew Jones <andrew.jones@linux.dev> <drjones@redhat.com>
 Andrew Morton <akpm@linux-foundation.org>
 Andrew Murray <amurray@thegoodpenguin.co.uk> <amurray@embedded-bits.co.uk>
 Andrew Murray <amurray@thegoodpenguin.co.uk> <andrew.murray@arm.com>
_

Patches currently in -mm which might be from andrew.jones@linux.dev are


