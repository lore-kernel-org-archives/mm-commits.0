Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A083634A77C
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 19:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766517848; cv=none; b=LVlE5rZTYdpuPAxIFH/2AR91By3EXH8hxMOVLbT8tgg0y0P5PfOa81lEkKq2bm1YCo+pc6GfHGs3gRaqdx5ARGYT3PcfLmlm8tfWzfVhogTh5Ik+pUE/m1bOXE3tEeQl8PD5vJTFxP8dgUn0Gk2NKRWCJOsa/UlZTQGABwtLpaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766517848; c=relaxed/simple;
	bh=sjOZqHGFQ6cy0jnv503Wv3YfUexksjsJE3AZlfg52/Q=;
	h=Date:To:From:Subject:Message-Id; b=LH2fWstY6GzA0IRW7gaDjq8VpkAfaEkXNBzfEG1W+ILJoA8ZiQk00NO9kzZXga3MapLxVjM95FesTj7CZHvb7U4M2J6YDWggctxy+6IumGa2HvtwxH3QUs+xgTaM5qLZZcY1+fMSElbNwVcvNC47RU7fMHvSbjHadUrUaSpa9qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JVcJGaS/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JVcJGaS/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B9FC113D0;
	Tue, 23 Dec 2025 19:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766517848;
	bh=sjOZqHGFQ6cy0jnv503Wv3YfUexksjsJE3AZlfg52/Q=;
	h=Date:To:From:Subject:From;
	b=JVcJGaS/yUqSncSKTHt0H8pR5K89YqvnppKdgxQqsd/uV1KVfAU+AUkIvjXaXY1o5
	 cB6Xze2jhJZNaPdtu7zdjtZLoYnn4tP09S/xbMoizX2yzpOHFqsElUbmhSaSFLT+zI
	 RLa6F8azprPlpaJt0T/RmDSM7+Y6bk57YnINfLeQ=
Date: Tue, 23 Dec 2025 11:24:07 -0800
To: mm-commits@vger.kernel.org,hverkuil@kernel.org,bartosz.golaszewski@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-one-straggling-entry-for-bartosz-golaszewski.patch removed from -mm tree
Message-Id: <20251223192408.24B9FC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update one straggling entry for Bartosz Golaszewski
has been removed from the -mm tree.  Its filename was
     maintainers-update-one-straggling-entry-for-bartosz-golaszewski.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: MAINTAINERS: update one straggling entry for Bartosz Golaszewski
Date: Thu, 4 Dec 2025 11:45:31 +0100

The entry for the Qualcomm bluetooth driver only now got sent upstream and
still has my old address.  Update it to use the kernel.org one.

Link: https://lkml.kernel.org/r/20251204104531.22045-1-bartosz.golaszewski@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Hans Verkuil <hverkuil@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-update-one-straggling-entry-for-bartosz-golaszewski
+++ a/MAINTAINERS
@@ -21346,7 +21346,7 @@ F:	Documentation/devicetree/bindings/net
 F:	drivers/net/wwan/qcom_bam_dmux.c
 
 QUALCOMM BLUETOOTH DRIVER
-M:	Bartosz Golaszewski <brgl@bgdev.pl>
+M:	Bartosz Golaszewski <brgl@kernel.org>
 L:	linux-arm-msm@vger.kernel.org
 S:	Maintained
 F:	drivers/bluetooth/btqca.[ch]
_

Patches currently in -mm which might be from bartosz.golaszewski@oss.qualcomm.com are


