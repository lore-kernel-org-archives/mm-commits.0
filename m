Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E7EEC41513
	for <mm-commits@archiver.kernel.org>; Thu, 10 Aug 2023 18:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbjHJS5P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Aug 2023 14:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234751AbjHJS5P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2023 14:57:15 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D2A22700
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 11:57:14 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5AAADD75;
        Thu, 10 Aug 2023 11:57:56 -0700 (PDT)
Received: from [192.168.0.23] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 26CDE3F6C4;
        Thu, 10 Aug 2023 11:57:12 -0700 (PDT)
Message-ID: <14b4ed13-086e-45a5-8541-f639a6036897@arm.com>
Date:   Thu, 10 Aug 2023 19:57:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-large_anon_folio-for-improved-performance.patch added to
 mm-unstable branch
Content-Language: en-GB
To:     Yu Zhao <yuzhao@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     David Hildenbrand <david@redhat.com>, mm-commits@vger.kernel.org,
        ziy@nvidia.com, ying.huang@intel.com, willy@infradead.org,
        shy828301@gmail.com, mcgrof@kernel.org,
        kirill.shutemov@linux.intel.com, itaru.kitayama@gmail.com,
        fengwei.yin@intel.com, catalin.marinas@arm.com,
        anshuman.khandual@arm.com
References: <20230810163130.E3D10C433C8@smtp.kernel.org>
 <279ce23c-8331-2b7c-86d3-b318f2c157af@redhat.com>
 <20230810102545.6a135af6009f436601c1c199@linux-foundation.org>
 <CAOUHufbuMAaonfpm0K=sg7qhEA2vzaoeNxKqqHcjtheircGnfw@mail.gmail.com>
From:   Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <CAOUHufbuMAaonfpm0K=sg7qhEA2vzaoeNxKqqHcjtheircGnfw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 10/08/2023 18:36, Yu Zhao wrote:
> On Thu, Aug 10, 2023 at 11:25 AM Andrew Morton
> <akpm@linux-foundation.org> wrote:
>>
>> On Thu, 10 Aug 2023 18:42:42 +0200 David Hildenbrand <david@redhat.com> wrote:
>>
>>> On 10.08.23 18:31, Andrew Morton wrote:
>>>>
>>>> The patch titled
>>>>       Subject: mm: LARGE_ANON_FOLIO for improved performance
>>>> has been added to the -mm mm-unstable branch.  Its filename is
>>>>       mm-large_anon_folio-for-improved-performance.patch
>>>>
>>>
>>> It's good to give these patches some early testing in -next.
>>>
>>> But let's wait for more review and acks before we pull this into mm-stable.
>>>
>>
>> OK, I thought the dust had adequately settled on this series.
>>
>> I'll await the next version ;)
> 
> Thanks. Close but not yet :)

Yes sorry if the cover letter was not clear - it does state that we are still
waiting for some other changes to land before we can merge this, but its quite
well burried. Looks like Yu still has some issues that will need to be discussed
too.
