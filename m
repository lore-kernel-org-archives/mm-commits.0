Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1201EB3D
	for <mm-commits@vger.kernel.org>; Sat, 15 Jun 2024 17:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718473431; cv=none; b=RtLq+FkihbAEwzpsYyQMpM5mgUQY6nq/aezvMXJFnPaxz0zNrgpcuHibDAXbW7Z7z28r2x1V/N0uzxORHNF0SvaJFEJAlPswklMI13cEwr8qJco6pkf8hRjAt0Spz4PP5dCSd+rkvfXURoC8elpNoCNQCpi3uD8cUtim5A8L6KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718473431; c=relaxed/simple;
	bh=NA9/jXvC/mvkJv2fn8MlfFUFUgdK1hlGIHYMteCQhrM=;
	h=Date:To:From:Subject:Message-Id; b=lS/b2DQJifPmr9cNtDF5ojRb+0cLHTTjUkIi4QjOcWnA38g9WNd2ZY/jfxhsP85CVX/JmQZTMf5gc5cXOEjvwZX0XeLr8ck1Niog7eWJ8na31aCUICgs2vF+LeyZGsp1dvetIOvFhc3a5mGMVr01aFvCZSQVaAVqyJVImHFFcgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AQeHivOq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AQeHivOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E4FC116B1;
	Sat, 15 Jun 2024 17:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718473430;
	bh=NA9/jXvC/mvkJv2fn8MlfFUFUgdK1hlGIHYMteCQhrM=;
	h=Date:To:From:Subject:From;
	b=AQeHivOqE4WKHLqXtIhWFN7WEDVTOpix9fSKwuWJE/S+y19tld6ebj6teVNqfpYH6
	 NWHKmCA+IP46RKh+3PZC0oaJ4OfLdP+X8a9IfXqPzGM+ohczudxIAty19kKYfl61Df
	 oBRjFYy0O3R55kvCI9K/7YUXrSlxMPKOKChPNraM=
Date: Sat, 15 Jun 2024 10:43:50 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@infradead.org,bhe@redhat.com,lstoakes@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-remove-myself-as-vmalloc-reviewer.patch removed from -mm tree
Message-Id: <20240615174350.90E4FC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: remove Lorenzo as vmalloc reviewer
has been removed from the -mm tree.  Its filename was
     maintainers-remove-myself-as-vmalloc-reviewer.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: MAINTAINERS: remove Lorenzo as vmalloc reviewer
Date: Sun, 2 Jun 2024 21:55:10 +0100

I haven't had the bandwidth to review vmalloc patches recently and I
suspect I won't be able to do so consistently moving forwards, so I think
it's best if I remove myself as reviewer for the time being.

Link: https://lkml.kernel.org/r/20240602205510.108807-1-lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~maintainers-remove-myself-as-vmalloc-reviewer
+++ a/MAINTAINERS
@@ -23974,7 +23974,6 @@ VMALLOC
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Uladzislau Rezki <urezki@gmail.com>
 R:	Christoph Hellwig <hch@infradead.org>
-R:	Lorenzo Stoakes <lstoakes@gmail.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
_

Patches currently in -mm which might be from lstoakes@gmail.com are


