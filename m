Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B312337DAA9
	for <mm-commits@vger.kernel.org>; Sat,  5 Sep 2026 18:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788634094; cv=none; b=BKYOA/JiYHXy6AKDRijW6Pa/NgQ8BnO2V9MveaMq8dUxsW0RRa8h+DmPCeRVb8E5TD0s2Y6p3toD96M/UtyXssChHAqCouHLWTtnHF9dYC8hVsJECRmKZVQXyG35uu/8p9O+HYZJV+y7pisTydOv0XAmLiIbwstnVePCJ41VV40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788634094; c=relaxed/simple;
	bh=vJyd9ym3nYHL3upDtvKhH6r+G2Jx8IOhgCmFK+WxYLk=;
	h=Date:To:From:Subject:Message-Id; b=T/cOGOnlgY21r+KVEZBdG/wcKZHxvWV9/Mz+mqurvLq5k7LGWad9yrOmbQl99ITOOR4Ggyp/BFBWXVJUV6cByPbvqc1tUcaa4+3NXy1cVwiZ7iIJFZav1wWCoxu4A5wCYUG99B1yhpO0LE+90do4AUIR9CNLutfYDoaObXXNJTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WQl/nNZ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WQl/nNZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651A41F00A3D;
	Sat,  5 Sep 2026 18:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788634092;
	bh=Z+p1crkR5PSG65QVGxw33/dikfsiC41ViTXqOXLNprU=;
	h=Date:To:From:Subject;
	b=WQl/nNZ7Y+6agdS/XGm1jPiLiRXUN5Jn+LMRwJ4Ml5TlK3SljNUtPF6EGw5F4oPgE
	 4Nepy9tYZ3KRFLddHiMG/1JIsdETbm/JCevHMgE47uFsMo3DOsg615LeUH6AS1RITd
	 2hw4iWb+64CEQjKpQQSv4OiGLN+fzyX5pVgO5MWc=
Date: Sat, 05 Sep 2026 11:48:12 -0700
To: mm-commits@vger.kernel.org,coiby.xu@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-map-coiby-xus-address.patch removed from -mm tree
Message-Id: <20260905184812.651A41F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: map Coiby Xu's address
has been removed from the -mm tree.  Its filename was
     mailmap-map-coiby-xus-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Coiby Xu <coiby.xu@gmail.com>
Subject: mailmap: map Coiby Xu's address
Date: Fri, 28 Aug 2026 16:41:06 +0800

Point to my gmail address as I've left Red Hat.

Link: https://lore.kernel.org/20260828084106.1494733-1-coiby.xu@gmail.com
Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-map-coiby-xus-address
+++ a/.mailmap
@@ -222,6 +222,7 @@ Chuck Lever <cel@kernel.org> <chuck.leve
 Chuck Lever <cel@kernel.org> <cel@netapp.com>
 Chuck Lever <cel@kernel.org> <cel@citi.umich.edu>
 Claudiu Beznea <claudiu.beznea@tuxon.dev> <claudiu.beznea@microchip.com>
+Coiby Xu <coiby.xu@gmail.com> <coxu@redhat.com>
 Colin Ian King <colin.i.king@gmail.com> <colin.king@canonical.com>
 Corey Minyard <minyard@acm.org>
 Damian Hobson-Garcia <dhobsong@igel.co.jp>
_

Patches currently in -mm which might be from coiby.xu@gmail.com are


