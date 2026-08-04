Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E4C433BD4
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816321; cv=none; b=Tg2/3NDUm5uMF+H//RyG6Z1V92ztFYIdzMZc5H6un/SG7qHyge9pp5TRhdBp7dLUl1Na0FvHMxgXgH7RP64tm6+MTXF3Cfkkk/6QcUysfLZtQhqOrWbN8sGS6S2xBgvD9RJxNF7MF9Gz8moZNthXGsb4RZ2mkHrLM4FgU4I+Sjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816321; c=relaxed/simple;
	bh=dC/OXkIYRig5c10T1/WzdQC6r1kIO68quXHNtsxzKYA=;
	h=Date:To:From:Subject:Message-Id; b=MX+qw1BHRRMWZpARR35TUZeag7FQqXFisP2ZLXaGaePPZ48q7XDXkx/ZGpcW1tEBMJ1klI49bZJ0uwAbIJxpx1A0M5NWAdJVV6SjuMtB8I81kqXtzJRYGfo81uO+CQtIR1StYWO2rEWb8cgwngwtTZ+BvKrDvcEyvdz2YiaJbxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2kSmq4IH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2kSmq4IH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA071F000E9;
	Tue,  4 Aug 2026 04:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816319;
	bh=KZRioft1q9dHUqau8MmmeZJf+uoR4cYZVUG4meEiBfQ=;
	h=Date:To:From:Subject;
	b=2kSmq4IHmeqkjh73sD2RKV96q8RzF31+gqfRpcgp4L2zRNfpsmHqOT3OlrfbOQmz9
	 Bh8YVbtccJUCQW188A2bZQOz66H7Ktp6myuSL/mlFKZHReY6bMHXJuIwyV3mu+8Ew6
	 zuMgDb0RQCJs/TuuHvjb3cMyp7AOPyHhsMxXUS7c=
Date: Mon, 03 Aug 2026 21:05:19 -0700
To: mm-commits@vger.kernel.org,pjw@kernel.org,thecharlesjenkins@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-add-entry-for-charlie-jenkins.patch removed from -mm tree
Message-Id: <20260804040519.BAA071F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: add entry for Charlie Jenkins
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-charlie-jenkins.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Charlie Jenkins <thecharlesjenkins@gmail.com>
Subject: mailmap: add entry for Charlie Jenkins
Date: Thu, 09 Jul 2026 00:31:04 -0700

My Rivos email started bouncing so redirect to my personal email.

Link: https://lore.kernel.org/20260709-mailmap-v1-1-74d98b8149d6@gmail.com
Signed-off-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Cc: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-charlie-jenkins
+++ a/.mailmap
@@ -192,6 +192,7 @@ Carlos Bilbao <carlos.bilbao@kernel.org>
 Changbin Du <changbin.du@intel.com> <changbin.du@gmail.com>
 Chao Yu <chao@kernel.org> <chao2.yu@samsung.com>
 Chao Yu <chao@kernel.org> <yuchao0@huawei.com>
+Charlie Jenkins <thecharlesjenkins@gmail.com> <charlie@rivosinc.com>
 Chen-Yu Tsai <wens@kernel.org> <wens@csie.org>
 Chester Lin <chester62515@gmail.com> <clin@suse.com>
 Chris Chiu <chris.chiu@canonical.com> <chiu@endlessm.com>
_

Patches currently in -mm which might be from thecharlesjenkins@gmail.com are


