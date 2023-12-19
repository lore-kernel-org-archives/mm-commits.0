Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F48218B0D
	for <mm-commits@vger.kernel.org>; Tue, 19 Dec 2023 11:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB88F1FB;
	Tue, 19 Dec 2023 03:26:00 -0800 (PST)
Received: from [10.1.32.152] (XHFQ2J9959.cambridge.arm.com [10.1.32.152])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AB93D3F738;
	Tue, 19 Dec 2023 03:25:13 -0800 (PST)
Message-ID: <5e49d4cf-3ba3-4d8f-9c98-09c0ef898e35@arm.com>
Date: Tue, 19 Dec 2023 11:25:12 +0000
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + arm64-mm-set_pte-new-layer-to-manage-contig-bit.patch added to
 mm-unstable branch
Content-Language: en-GB
To: David Hildenbrand <david@redhat.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
 yuzenghui@huawei.com, willy@infradead.org, wangkefeng.wang@huawei.com,
 vincenzo.frascino@arm.com, suzuki.poulose@arm.com, shy828301@gmail.com,
 ryabinin.a.a@gmail.com, oliver.upton@linux.dev, maz@kernel.org,
 mark.rutland@arm.com, jhubbard@nvidia.com, james.morse@arm.com,
 glider@google.com, dvyukov@google.com, catalin.marinas@arm.com,
 ardb@kernel.org, apopple@nvidia.com, anshuman.khandual@arm.com,
 andreyknvl@gmail.com, 21cnbao@gmail.com
References: <20231218172316.08623C433C8@smtp.kernel.org>
 <20231219101038.GA6307@willie-the-truck>
 <563d4703-e726-4e53-b163-2af192423373@arm.com>
 <145ac178-3bed-46fb-8fa5-0ae8293e43b4@redhat.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <145ac178-3bed-46fb-8fa5-0ae8293e43b4@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 19/12/2023 10:53, David Hildenbrand wrote:
>>> In any case, this series makes significant changes to the low-level
>>> arm64 mm code and I don't think many of us will be around in the next
>>> couple of weeks to deal with the fallout if it kicks up any issues.
>>>
>>> Andrew -- if Ryan doesn't object, please can you drop this for now?
>>
>> It's always nice to get linux-next soak time; Is there a middle ground where we
>> keep it in mm-unstable for a bit but don't progress it to mm-stable, and if
>> there are any arm64 bug reports we drop it? Or is that too complicated?
> 
> If stuff is lurking too long in -next/mm-unstable, it might create conflicts
> with other patch sets that might go upstream / to mm-stable faster.

Yeah fair enough (can't imagine what you might be thinking of :) ).

Let's drop it then.

> 

