Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F3F3009DE
	for <mm-commits@vger.kernel.org>; Tue, 24 Feb 2026 19:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771960453; cv=none; b=dKKskJQeYZXCz0MmG30dlpXm1s3tJUulKTrOYxS8CNQ8uCtcvac0IdLbBS9IwLM3XWYcHyJXpnnJ1P7ZxMOnVWXnQ0ZFNvreoIQ8+t9kWqU/yFqC8oaNH10z32MFhzHtjhb5GlwiCmbznu1RNyQPxOFfwcZ064e24sOJmPREttQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771960453; c=relaxed/simple;
	bh=odTn7CLQcQCaImfQjxBCC5haxMZlRORR4p+1C+tEA/M=;
	h=Date:To:From:Subject:Message-Id; b=p/nTmDSriTzg1kqCOtPu+Mj6dlrwnDWrgA2POFMnhQA7TNSQnPjRlh/KAf0tdONMcKXr2xTtu32cOwUZAvU6z693YEBYnWTZ1WO9rqS78PZckL2+zqkm0h8pekXyYH+MYyE2+4yEfQ3aPxeBwgVPLkMvXj33PkH8ly/xaMQJIdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sn8qJsn4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sn8qJsn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FD6C116D0;
	Tue, 24 Feb 2026 19:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771960452;
	bh=odTn7CLQcQCaImfQjxBCC5haxMZlRORR4p+1C+tEA/M=;
	h=Date:To:From:Subject:From;
	b=sn8qJsn4r/5+Cwy7PuhxLL+9z8TpjLGofq+aeGBJzz6d/mBbSeW3s8rH4U/I4/w/z
	 k6dXmghQ1m2S3M04xzpsS44DJxycCrWTNmO5e1c19MqWZZjyuicc/vGAqqZGiq9RVZ
	 79gaZCMCzyGIPfL2DguYftuRNp3l7w0zEGfroDLg=
Date: Tue, 24 Feb 2026 11:14:12 -0800
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,yosry@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-yosry-ahmeds-email-address.patch removed from -mm tree
Message-Id: <20260224191412.A9FD6C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update Yosry Ahmed's email address
has been removed from the -mm tree.  Its filename was
     maintainers-update-yosry-ahmeds-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosry@kernel.org>
Subject: MAINTAINERS: update Yosry Ahmed's email address
Date: Mon, 23 Feb 2026 16:00:26 +0000

Use my kernel.org email address.

Link: https://lkml.kernel.org/r/20260223160027.122307-1-yosry@kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    3 ++-
 MAINTAINERS |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/.mailmap~maintainers-update-yosry-ahmeds-email-address
+++ a/.mailmap
@@ -892,7 +892,8 @@ Yanteng Si <si.yanteng@linux.dev> <siyan
 Ying Huang <huang.ying.caritas@gmail.com> <ying.huang@intel.com>
 Yixun Lan <dlan@kernel.org> <dlan@gentoo.org>
 Yixun Lan <dlan@kernel.org> <yixun.lan@amlogic.com>
-Yosry Ahmed <yosry.ahmed@linux.dev> <yosryahmed@google.com>
+Yosry Ahmed <yosry@kernel.org> <yosryahmed@google.com>
+Yosry Ahmed <yosry@kernel.org> <yosry.ahmed@linux.dev>
 Yu-Chun Lin <eleanor.lin@realtek.com> <eleanor15x@gmail.com>
 Yusuke Goda <goda.yusuke@renesas.com>
 Zack Rusin <zack.rusin@broadcom.com> <zackr@vmware.com>
--- a/MAINTAINERS~maintainers-update-yosry-ahmeds-email-address
+++ a/MAINTAINERS
@@ -29186,7 +29186,7 @@ K:	zstd
 
 ZSWAP COMPRESSED SWAP CACHING
 M:	Johannes Weiner <hannes@cmpxchg.org>
-M:	Yosry Ahmed <yosry.ahmed@linux.dev>
+M:	Yosry Ahmed <yosry@kernel.org>
 M:	Nhat Pham <nphamcs@gmail.com>
 R:	Chengming Zhou <chengming.zhou@linux.dev>
 L:	linux-mm@kvack.org
_

Patches currently in -mm which might be from yosry@kernel.org are


